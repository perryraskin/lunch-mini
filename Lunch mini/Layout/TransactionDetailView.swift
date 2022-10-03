//
//  ContactDetailView.swift
//  Declarative UI
//
//  Created by Perry Raskin on 06/29/2022.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import Combine
import SwiftUI
import Foundation

struct TransactionDetailView: View {
    @Environment(\.openURL) var openUrl
    
    let transaction: Transaction

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://picsum.photos/100"))
                .clipShape(Circle())
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text(transaction.original_name)
                    .font(.title)
                    .foregroundColor(.primary)

                Text(transaction.payee)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if transaction.amountFloat ?? 0 < 0 {
                    Text("💵 ") +
                    Text("$")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                    + Text(transaction.amount.dropFirst().dropLast().dropLast())
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                }
                else {
                    Text("💵 ") +
                    Text("$")
                        .font(.subheadline)
                        .bold()
                    + Text(transaction.amount.dropLast().dropLast())
                        .font(.subheadline)
                        .bold()
                }
                Text("🗓️ ") +
                Text(transaction.date)
                    .font(.subheadline)
                Text("💳 ") +
                Text(transaction.PlaidAccount?.mask ?? "")
                    .font(.subheadline)
                Text(transaction.category_name ?? "Uncategorized")
                    .font(.headline)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.blue.opacity(0.5)))
                    .foregroundColor(.white)

//                Button(action: {
//                    let telephone = "tel://"
//                    let formattedString = telephone + self.transaction.date
//                    guard let url = URL(string: formattedString) else { return }
//                    openUrl(url)
//                }) {
//                    Text(transaction.date)
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                }
            }
            Spacer()
        }
    }
}

//struct ContactDetailView_Previews: PreviewProvider {
//    static let exampleContact = Contact(id: "1234", name: "Perry Raskin", image: URL(string: "https://i.pravatar.cc/300")!, phone: "(xx) xxxx-xxxx", email: "perry@email.com")
//
//    static var previews: some View {
//        return TransactionDetailView(contact: Self.exampleContact)
//    }
//}
