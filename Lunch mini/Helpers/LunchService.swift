//
//  LunchService.swift
//  Lunch mini
//
//  Created by Ethan Lipnik on 6/29/22.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Foundation

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
        let url = apiUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let data = try await URLSession.shared.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
}
