//
//  DestinationListingView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//
// this view is required so that custom user sorting can be performed
// localizedStandardContains is usually better for user-facing searches than contains because it avoids case-sensitive searching

import SwiftUI
import SwiftData

struct DestinationListingView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var destinations: [Destination]
    
    init(sort: SortDescriptor<Destination>, searchString: String) {
        _destinations = Query(
            filter: #Predicate {
                if searchString.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(searchString)
                }
            }, 
            sort: [sort]
        )
    }
    
    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)

                        Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }
    
    func deleteDestinations(at offsets: IndexSet) {
        for offset in offsets {
            let destination = destinations[offset]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    DestinationListingView(sort: SortDescriptor(\Destination.name), searchString: "")
}
