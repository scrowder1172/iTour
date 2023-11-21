//
//  ContentView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var path = [Destination]()
    
    @State private var sortOrder: SortDescriptor = SortDescriptor(\Destination.name)
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sort: sortOrder, searchString: searchText)
            .navigationTitle("iTour")
            .searchable(text: $searchText)
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    
                    Menu("Add Destinations", systemImage: "plus") {
                        Button("Add Samples", action: addSamples)
                        Button("Create New Destination", action: addDestination)
                    }
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\Destination.name))
                            
                            Text("Priority")
                                .tag(SortDescriptor(\Destination.priority, order: .reverse))
                            
                            Text("Date")
                                .tag(SortDescriptor(\Destination.date))
                        }
                        .pickerStyle(.inline)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    func addSamples() {
        let rome: Destination = Destination(name: "_Sample Destination1", details: "This is an example of what a destination may look like.", priority: 1)
        let florence: Destination = Destination(name: "_Sample Destination2")
        let naples: Destination = Destination(name: "_Sample Destination3")
        
        modelContext.insert(rome)
        modelContext.insert(florence)
        modelContext.insert(naples)
    }
    
    func addDestination() {
        // creates a new destination using default values that the user can edit
        let destination: Destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
}

#Preview {
    ContentView()
}
