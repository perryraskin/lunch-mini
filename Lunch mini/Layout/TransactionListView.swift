//
//  ContactListView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI

struct Transaction: Codable, Identifiable {
    let id: Int
    let original_name: String
    let amount: String
    let payee: String
    let date: String
    let category_id: Int
}

struct TransactionsResponse: Codable {
    let transactions: [Transaction]
}

//var apiUrl = "https://jsonplaceholder.typicode.com/posts/1/comments"
var apiUrl = "https://dev.lunchmoney.app/v1"

class apiCall {
    @AppStorage("apiKey") var apiKey: String = ""
    
    func printApiKey() {
        print("API KEY:")
        print(apiKey)
    }
    
    func getTransactions(completion:@escaping (TransactionsResponse) -> ()) {
        guard let url = URL(string: "\(apiUrl)/transactions") else { return }
        
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//          let date = dateFormatter.date(from:isoDate)!
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let res = try? JSONDecoder().decode(TransactionsResponse.self, from: data!)
            else {
                print("ERROR!")
                return
            }
//            print(res.transactions)
            
//            var updatedTransactions : [Transaction]
//            for t in res.transactions {
//                var transaction = t
//                t.date =
//            }

//            var sortedTransactions = res.transactions.sorted(by: $0. > $1.date)
            DispatchQueue.main.async {
                
//                let date = dateFormatter.date(from:isoDate)!
                
                completion(res)
            }
            
//            guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No data")
//                    return
//                }
//                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                if let responseJSON = responseJSON as? [String: Any] {
//                    print(responseJSON)
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