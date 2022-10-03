//
//  TransactionListView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI

struct TransactionListView: View {
    // This is specific to the category ID in my Lunch Money account
    let payment_category_id = 348205
    
    @State var plaid_accounts = [PlaidAccount]()
    @State var transactions = [Transaction]()
    @State var categories = [Category]()
    @StateObject var lunchService = LunchService()
//    @StateObject var contactsService = ContactsService()

    var body: some View {
        VStack {
            List(transactions) { transaction in
                NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                    VStack(alignment: .leading) {
                        Text(transaction.original_name)
                            .font(.title3)
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
                await getTransactions()
            }
            .navigationTitle("Transactions")
            .refreshable {
                await getPlaidAccounts()
                await getTransactions()
            }

            //            List(contactsService.contactList.contacts) { contact in
            //                NavigationLink(destination: ContactDetailView(contact: contact)) {
            //                    ListItem(contact: contact)
            //                }
            //            }
            //            .task {
            //                do {
            //                    try await contactsService.fetch()
            //                } catch {
            //                    print(error)
            //                }
            //            }
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
    
    func getTransactions() async {
        await getCategories()
        do {
            print("Getting transactions...")
            let transactionsResponse: TransactionsResponse = try await lunchService.get("transactions")
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
