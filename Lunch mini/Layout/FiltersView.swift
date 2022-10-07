//
//  FiltersView.swift
//  Lunch mini
//
//  Created by Perry Raskin on 10/7/22.
//  Copyright © 2022 Perry Raskin. All rights reserved.
//

import SwiftUI
import SwiftDate

struct FiltersView: View {
    let now = Date()
//    @ObservedObject var filter = TransactionListFilters()
//    @State var date_from = Date()
//    @State var date_to = Date()
    
    @Binding var showFiltersView: Bool
    @Binding var filter: FilterItem
    var refreshTransactions: (String, String) async -> ()
    
    @State var date_from_str = ""
    @State var date_to_str = ""
    
    var body: some View {
        //      Text("Filters")
        //          .font(.title3)
        //          .bold()
        //          .padding(.top)
        
        NavigationView {
            List {
                DatePicker("From", selection: $filter.date_from, displayedComponents: .date)
//                    .onChange(of: $filter.date_from) { newValue in
//                        self.date_from_str = String(newValue.year)
//                    }
                DatePicker("To", selection: $filter.date_to, displayedComponents: .date)
//                    .onChange(of: date_to) { newValue in
//                        filter.date_to = date_to
//                    }
                Button(
                    action: {
                        self.showFiltersView = false
//                        self.refreshTransactions(, )
                }, label: {
                        Text("Apply")
                    }
                )
            } .navigationBarTitle("Filters").navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

//struct FiltersView_Previews: PreviewProvider {
//    static let filterPreview = FilterItem(
//        date_from: Date(),
//        date_to: Date()
//    )
//    static var previews: some View {
//        FiltersView(filter: filterPreview)
//    }
//}
