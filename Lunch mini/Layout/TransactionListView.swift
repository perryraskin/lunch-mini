//
//  TransactionListView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI
import SwiftUI_FAB
import Popovers
import SwiftDate

struct TransactionListView: View {
    // This is specific to the category ID in my Lunch Money account
    let payment_category_id = 348205
    
    @State var plaid_accounts = [PlaidAccount]()
    @State var transactions = [Transaction]()
    @State var categories = [Category]()
    @StateObject var lunchService = LunchService()
//    @StateObject var contactsService = ContactsService()
   
    let now = Date()
    let default_date_from = Date().dateAt(.startOfMonth) + 4.hours
    @State var default_date_from_str: String = ""
    @State var default_date_to_str: String = ""
    
    @State var showFilters: Bool = false
    @State var filter = FilterItem(
        date_from: Date().dateAt(.startOfMonth) + 4.hours,
        date_to: Date()
    )
    
    init() {
        print(default_date_from)
        print(Date())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(transactions) { transaction in
                    NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                        VStack(alignment: .leading) {
                            Text(transaction.original_name)
                                .bold()
                            if transaction.amountFloat ?? 0 < 0 {
                                Text("💵 ") +
                                Text("$")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.green)
                                + Text(transaction.amount.dropFirst().dropLast().dropLast())
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            else {
                                Text("💵 ") +
                                Text("$")
                                    .font(.subheadline)
                                    .bold()
                                + Text(transaction.amount.dropLast().dropLast())
                                    .font(.subheadline)
                                    .bold()
                            }
                            Text("🗓️ ") +
                            Text(transaction.date)
                                .font(.subheadline)
                            Text("💳 ") +
                            Text(transaction.PlaidAccount?.mask ?? "")
                                .font(.subheadline)
                            Text(transaction.category_name ?? "Uncategorized")
                                .font(.headline)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.blue.opacity(0.5)))
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .task {
                    await getPlaidAccounts()
                    await getTransactions(date_from: default_date_from_str, date_to: default_date_to_str)
                }
                .refreshable {
                    await getPlaidAccounts()
                    await getTransactions(date_from: default_date_from_str, date_to: default_date_to_str)
                }
            
                .floatingActionButton(
                    color: Color.black,
                    image: Image(systemName: "slider.horizontal.3").foregroundColor(.white)
                ) {
                    showFilters.toggle()
                }
                
            }
            .sheet(isPresented: $showFilters) {
                if #available(iOS 16.0, *) {
                    FiltersView(showFiltersView: $showFilters, filter: $filter, refreshTransactions: getTransactions)
                        .presentationDetents([.medium, .large])
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationBarTitle("Purchases")
            
            
        }
        
    }
    
    func getPlaidAccounts() async {
        do {
            let plaidAccountsResponse: PlaidAccountsResponse = try await lunchService.get("plaid_accounts")
            self.plaid_accounts = plaidAccountsResponse.plaid_accounts
        } catch let error { /// The `let error` part is optional
            print(error)
        }
    }

    func getCategories() async {
        do {
            let categoriesResponse: CategoriesResponse = try await lunchService.get("categories")
            self.categories = categoriesResponse.categories
        } catch let error { /// The `let error` part is optional
            print(error)
        }
    }
    
    func getTransactions(date_from: String, date_to: String) async {
        await getCategories()
        do {
            print("Getting transactions...")
            let from_month = default_date_from.month < 10 ? "0" + String(default_date_from.month) : String(default_date_from.month)
            let from_day = default_date_from.day < 10 ? "0" + String(default_date_from.day) : String(default_date_from.day)
            let to_month = now.month < 10 ? "0" + String(now.month) : String(now.month)
            let to_day = now.day < 10 ? "0" + String(now.day) : String(now.day)
            
            let default_date_from_str = String(default_date_from.year) + "-" + from_month + "-" + from_day
            let default_date_to_str = String(now.year) + "-" + to_month + "-" + to_day
            var params = "?start_date=" + date_from + "&end_date=" + date_to
            if (date_from == "") {
                params = "?start_date=" + default_date_from_str + "&end_date=" + default_date_to_str
            }
            print(params)
            let transactionsResponse: TransactionsResponse = try await lunchService.get("transactions" + params)
            var updatedTransactions = [Transaction]()
            // set category name for each transaction
            for t in transactionsResponse.transactions {
                // set category
                var adjustedT = t
                let category = categories.first { $0.id == t.category_id }

                adjustedT.category_name = category?.name ?? "Uncategorized"
                adjustedT.amountFloat = Float(t.amount)
                
                
                // set plaid account
                let plaid_account = plaid_accounts.first { $0.id == t.plaid_account_id }
                adjustedT.PlaidAccount = plaid_account
                
                // add the updated transaction
                updatedTransactions.append(adjustedT)
            }
            
            print("Found \(updatedTransactions.count) transactions!")
            self.transactions = updatedTransactions
//                .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                .reversed()
                .filter { $0.category_id != payment_category_id }
        } catch let error { /// The `let error` part is optional
            print(error)
        }
    }
    
    func getTotalCardSpendings(plaid_account_id: String) async {
        do {
            print("Getting account transactions...")
            let transactionsResponse: TransactionsResponse = try await lunchService.getAccountTransactions(plaid_account_id)
            
//            print(transactionsResponse)
            var totalSpendings: Float = 0.00
            for t in transactionsResponse.transactions {
                if (t.category_id != payment_category_id) {
                    totalSpendings = totalSpendings + Float(t.amount)!
                }
            }
            let totalSpendingsFormatted = NumberFormatter.localizedString(from: totalSpendings as NSNumber, number: .currency)
            print("Total spendings on card: \(totalSpendingsFormatted)")
//            self.totalSpendings = totalSpendingsFormatted
        } catch let error { /// The `let error` part is optional
            print(error)
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
