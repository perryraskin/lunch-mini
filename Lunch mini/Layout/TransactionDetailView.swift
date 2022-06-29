//
//  ContactDetailView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import SwiftUI
import Foundation





struct ContactDetailView: View {
    
        
    
    var contact: Contact
    
    var body: some View {
        
        
        VStack {
            CircleImage(url: contact.image)
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.title)
                    .foregroundColor(.primary)


                Text(contact.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + self.contact.phone
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                }) {
                Text(contact.phone)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            Spacer()
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let contact = Contact(id: "1234", name: "Perry Raskin", image: "https://i.pravatar.cc/300", phone: "(xx) xxxx-xxxx", email: "perry@email.com")
        return ContactDetailView(contact: contact)
    }
}
