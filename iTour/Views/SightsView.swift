//
//  SightsView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import SwiftUI
import SwiftData

struct SightsView: View {
    
    @Query(sort: \Sight.name) var sights: [Sight]
    
    @State private var path = [Sight]()
    
    @State private var sortOrder: [SortDescriptor] = [
        SortDescriptor(\Sight.name)
    ]
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            //SightsListingView(sort: sortOrder, searchString: searchText)
            List(sights) { sight in
                NavigationLink(value: sight.destination) {
                    Text(sight.name)
                }
            }
            .navigationTitle("Sights")
            //.searchable(text: $searchText)
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
        }
    }
}

#Preview {
    SightsView()
}
