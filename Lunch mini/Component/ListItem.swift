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
            AsyncImage(url: contact.image)
                .clipShape(Circle())
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: 40, height: 40)
            Text(contact.name)
            Spacer()
        }.padding()
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        return ListItem(contact: ContactDetailView_Previews.exampleContact)
    }
}
