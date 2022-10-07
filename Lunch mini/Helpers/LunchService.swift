//
//  LunchService.swift
//  Lunch mini
//
//  Created by Ethan Lipnik on 6/29/22.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Foundation

struct PlaidAccount: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let subtype: String
    let mask: String
    let institution_name: String
    let status: String
    let balance: String
    let limit: Int
}

struct PlaidAccountsResponse: Codable {
    let plaid_accounts: [PlaidAccount]
}

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
    var amountFloat: Float?
    let plaid_account_id: Int
    var PlaidAccount: PlaidAccount?
}

struct TransactionsResponse: Codable {
    var transactions: [Transaction] = []
}

@MainActor
class LunchService: ObservableObject {
    // var apiUrl = "https://jsonplaceholder.typicode.com/posts/1/comments"
    var apiUrl = URL(string: "https://dev.lunchmoney.app/v1")!

    @Published var categories: [Category] = []
    @Published var apiKey: String = {
        return UserDefaults.standard.string(forKey: "apiKey") ?? ""
    }()

    init() {
        //        print("API KEY:")
        //        print(apiKey)
        //        self.getCategories { (categoriesRes) in
        //            self.categories = categoriesRes.categories
        //        }
    }

    // This uses generics to simplify multiple functions
    func get<T: Decodable>(_ path: String) async throws -> T {
//        let url = apiUrl.appendingPathComponent(path)
        var urlString = "https://dev.lunchmoney.app/v1/" + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let data = try await URLSession.shared.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func getAccountTransactions<T: Decodable>(_ plaid_account_id: String) async throws -> T {
        let url = URL(string: "https://dev.lunchmoney.app/v1/transactions?start_date=2022-07-01&end_date=2022-10-01&plaid_account_id=\(plaid_account_id)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let data = try await URLSession.shared.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
}
