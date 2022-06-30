//
//  ContactListView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
}

struct CategoriesResponse: Codable {
    let categories: [Category]
}

struct Transaction: Codable, Identifiable {
    let id: Int
    let original_name: String
    let amount: String
    let payee: String
    let date: String
    let category_id: Int
    var category_name: String?
}

struct TransactionsResponse: Codable {
    var transactions: [Transaction] = []
}

//var apiUrl = "https://jsonplaceholder.typicode.com/posts/1/comments"
var apiUrl = "https://dev.lunchmoney.app/v1"

class apiCall {
    @State var categories: [Category] = []
    @AppStorage("apiKey") var apiKey: String = ""
    
    init() {
//        print("API KEY:")
//        print(apiKey)
//        self.getCategories { (categoriesRes) in
//            self.categories = categoriesRes.categories
//        }
    }
    
    func getCategories(completion:@escaping (CategoriesResponse) -> ()) {
        
        guard let url = URL(string: "\(apiUrl)/categories") else { return }
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let res = try? JSONDecoder().decode(CategoriesResponse.self, from: data!)
            else {
                print("CATEGORIES ERROR!")
                print(error)
                return
            }
//            print(res.categories)
            
            DispatchQueue.main.async {
                completion(res)
            }
//                }
        }
        .resume()
    }
    
    func getTransactions(completion:@escaping (TransactionsResponse) -> ()) {
        guard let url = URL(string: "\(apiUrl)/transactions") else { return }
        
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let transactionsRes = try? JSONDecoder().decode(TransactionsResponse.self, from: data!)
            else {
                print("ERROR!")
                print(error)
                return
            }
//            print(res.transactions)
            
            self.getCategories { (categoriesRes) in
                let categories = categoriesRes.categories

                DispatchQueue.main.async {
                    var updatedTransactionsRes = TransactionsResponse()
                    // set category name for each transaction
                    for t in transactionsRes.transactions {
                        var adjustedT = t
                        let category = categories.first { $0.id == t.category_id }

                        adjustedT.category_name = category?.name ?? "Uncategorized"
                        updatedTransactionsRes.transactions.append(adjustedT)
                    }
                    completion(updatedTransactionsRes)
                }
            }
            
            
//                }
        }
        .resume()
    }
}

struct ContactListView: View {
    @State var transactions = [Transaction]()
    @ObservedObject var networkLoader = NetworkLoader()
    @State var contactList = ContactList(contacts: [])
    var body: some View {
        return VStack {
            List(transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.original_name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(transaction.amount)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(transaction.date)
                        .font(.body)
                    Text(transaction.category_name ?? "Uncategorized")
                        .padding(4)
                        .background(Color.blue.opacity(0.5))
                        .foregroundColor(.white)
                        .font(.headline)
                }

            }
            .onAppear() {
                apiCall().getTransactions { (res) in
                    self.transactions = res.transactions
                    self.transactions = self.transactions
                        .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                        .filter { $0.category_id != 348205 }
                }
//                apiCall().printApiKey()
            }.navigationTitle("Transactions")
        }
//        return VStack {
//            List(contactList.contacts, id: \.id) { contact in
//                NavigationLink(destination: ContactDetailView(contact: contact)) {
//                    ListItem(contact: contact)
//                }
//            }.onReceive(networkLoader.didChange) { result in
//                self.contactList = result
//            }
//        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
