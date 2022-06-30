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
    @State var transactions = [Transaction]()
    @State var categories = [Category]()
    @StateObject var lunchService = LunchService()
//    @StateObject var contactsService = ContactsService()

    var body: some View {
        VStack {
            List(transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.original_name)
                        .font(.title3)
                        .bold()
                    if transaction.amountFloat ?? 0 < 0 {
                        Text(transaction.amount)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.green)
                    }
                    else {
                        Text(transaction.amount)
                            .font(.subheadline)
                            .bold()
                    }
                    Text(transaction.date)
                        .font(.body)
                    Text(transaction.category_name ?? "Uncategorized")
                        .font(.headline)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.blue.opacity(0.5)))
                        .foregroundColor(.white)
                }
            }
            .task {
                await getTransactions()
            }
            .navigationTitle("Transactions")
            .refreshable {
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
            let transactionsResponse: TransactionsResponse = try await lunchService.get("transactions")
            var updatedTransactions = [Transaction]()
            // set category name for each transaction
            for t in transactionsResponse.transactions {
                var adjustedT = t
                let category = categories.first { $0.id == t.category_id }

                adjustedT.category_name = category?.name ?? "Uncategorized"
                adjustedT.amountFloat = Float(t.amount)
                updatedTransactions.append(adjustedT)
            }
            self.transactions = updatedTransactions
                .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                .filter { $0.category_id != 348205 }
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
