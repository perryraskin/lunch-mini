//
//  RulesView.swift
//  Lunch mini
//
//  Created by Perry Raskin on 10/3/22.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    @State private var enablePointsRules = true
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    VStack(alignment: .leading) {
                        Toggle("Enable points rules", isOn: $enablePointsRules)
                            .toggleStyle(SwitchToggleStyle(tint: .green))

                        if enablePointsRules {
                            Text("Points rules is enabled!")
                        }
                    }
                }
                
            }
            .navigationBarTitle("Rules")
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
