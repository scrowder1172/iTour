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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sights) {sight in
                    NavigationLink(value: sight.destination) {
                        Text(sight.name)
                    }
                }
            }
            .navigationTitle("Sights")
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
        }
    }
}

#Preview {
    SightsView()
}
