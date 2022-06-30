//
//  ContentView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //    @State var saveApiKey = false
    @AppStorage("apiKey") var apiKey: String = ""
    @AppStorage("saveApiKey") var saveApiKey: Bool = false
    //    @UserDefaults("apiKey")
    var body: some View {

        NavigationView {
            if saveApiKey && apiKey != "" {
                TransactionListView()
            } else {
                Form {
                    TextField("API Key", text: $apiKey)
                    //                        Text("Stored string: \(apiKey)")
                    //                                  TextField(apiKey, text: $apiKey)
                    Button("Submit") {
                        apiKey = apiKey
                        print(apiKey)
                        saveApiKey = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
