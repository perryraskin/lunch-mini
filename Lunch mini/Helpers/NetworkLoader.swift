//
//  NetworkLoader.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI

class NetworkLoader: ObservableObject {
    var didChange = PassthroughSubject<ContactList, Never>()
    
    var result: ContactList = ContactList(contacts: []) {
        didSet {
            didChange.send(result)
        }
    }
    
    init() {
        if let url = URL(string: "https://gist.githubusercontent.com/anacoimbrag/50cb96b6c57100c1881be36d98bc4d2a/raw/1c2176ffaafc54baeb82f62d81e7a3fa4615244a/contactData.json") {
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let model = try decoder.decode(ContactList.self, from: data)
                            self.result = model
                        } catch let e {
                            print(e)
                        }
                    }
                }
            }
            session.resume()
        }
    }
}
