//
//  ListItem.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import SwiftUI

struct ListItem: View {
    var contact: Contact
    
    var body: some View {
        HStack {
            CircleImage(url: contact.image)
            .frame(width: 40, height: 40)
            Text(contact.name)
            Spacer()
        }.padding()
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        let contact = Contact(id: "1234", name: "Jane Doe", image: "https://i.pravatar.cc/150", phone: "(xx) xxxx-xxxx", email: "jane@email.com")
        return ListItem(contact: contact)
    }
}
