//
//  Contact.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Foundation

struct Contact: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var image: URL
    var phone: String
    var email: String
}

struct ContactList: Decodable {
    var contacts: [Contact]
}
