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
    @Environment(\.openURL) var openUrl
    
    let contact: Contact

    var body: some View {
        VStack {
            AsyncImage(url: contact.image)
                .clipShape(Circle())
                .aspectRatio(1/1, contentMode: .fit)
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
                    openUrl(url)
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
    static let exampleContact = Contact(id: "1234", name: "Perry Raskin", image: URL(string: "https://i.pravatar.cc/300")!, phone: "(xx) xxxx-xxxx", email: "perry@email.com")

    static var previews: some View {
        return ContactDetailView(contact: Self.exampleContact)
    }
}
