//
//  SightsListingView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import SwiftUI
import SwiftData

struct SightsListingView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var sights: [Sight]
    
    init(sort: [SortDescriptor<Sight>], searchString: String) {
        _sights = Query(
            filter: #Predicate<Sight> {
                if searchString.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(searchString)
                }
            }
        )
    }
    
    var body: some View {
        List {
            ForEach(sights) { sight in
                NavigationLink(value: sight) {
                    VStack(alignment: .leading) {
                        Text(sight.name)
                    }
                }
            }
            .onDelete(perform: deleteSight)
        }
    }
    
    func deleteSight(at offsets: IndexSet) {
        for offset in offsets {
            let sight = sights[offset]
            modelContext.delete(sight)
        }
    }
}

#Preview {
    SightsListingView(sort: [SortDescriptor(\Sight.name)], searchString: "")
}
