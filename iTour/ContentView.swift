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
    
    @State private var sortOrder: [SortDescriptor] = [
        SortDescriptor(\Destination.name),
        SortDescriptor(\Destination.date)
        ]
    
    @State private var searchText: String = ""
    
    @State private var showFutureOnly: Bool = false
    
    @State private var minimumDate: Date = Date.distantPast
    let currentDate: Date = Date.now
    
    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sort: sortOrder, searchString: searchText, minimumDate: minimumDate)
            .navigationTitle("iTour")
            .searchable(text: $searchText)
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu("Add Destinations", systemImage: "plus") {
                        Button("Add Samples", action: addSamples)
                        Button("Create New Destination", action: addDestination)
                    }
                    
                    Menu("Filter", systemImage: "calendar") {
                        Picker("Filter", selection: $minimumDate) {
                            Text("Show all destinations")
                                .tag(Date.distantPast)
                            
                            Text("Show upcoming destinations")
                                .tag(currentDate)
                        }
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag([
                                    SortDescriptor(\Destination.name),
                                    SortDescriptor(\Destination.date)
                                    ])
                            
                            Text("Priority")
                                .tag([
                                    SortDescriptor(\Destination.priority, order: .reverse),
                                    SortDescriptor(\Destination.name),
                                    SortDescriptor(\Destination.date)
                                    ])
                            
                            Text("Date")
                                .tag([
                                    SortDescriptor(\Destination.date),
                                    SortDescriptor(\Destination.name)
                                    ])
                        }
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
