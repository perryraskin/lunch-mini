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
                        .background(Color.blue.opacity(0.5))
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

    func getTransactions() async {
        do {
            let transactionsResponse: TransactionsResponse = try await lunchService.get("transactions")
            self.transactions = transactionsResponse.transactions
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
