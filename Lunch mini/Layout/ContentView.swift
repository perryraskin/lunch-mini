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
        
        if saveApiKey && apiKey != "" {
            TabView {
                TransactionListView()
                .tabItem {
                    Label("Purchases", systemImage: "list.dash")
                }
                RulesView()
                .tabItem {
                    Label("Rules", systemImage: "slider.horizontal.2.rectangle.and.arrow.triangle.2.circlepath")
                }
            }
        } else {
            Form {
                TextField("API Key", text: $apiKey)
                Button("Submit") {
                    apiKey = apiKey
                    print(apiKey)
                    saveApiKey = true
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
