//
//  EditDestinationView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//
//  make modelContext a private var to avoid issues with init

import SwiftUI
import SwiftData

struct EditDestinationView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var newSightName: String = ""
    
    @Bindable var destination: Destination
    
    var body: some View {
        Form {
            TextField("Name", text: $destination.name)
            TextField("Details", text: $destination.details, axis: .vertical)
            DatePicker("Date", selection: $destination.date)
            
            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Sights") {
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }
                .onDelete(perform: deleteSight)
                
                HStack {
                    TextField("Add a new sight in \(destination.name)", text: $newSightName)
                    
                    Button("Add", action: addSight)
                }
            }
            
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSight() {
        guard newSightName.isEmpty == false else { return }
        
        withAnimation {
            let sight: Sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
    
    func deleteSight(at offsets: IndexSet) {
        for offset in offsets {
            let sight = destination.sights[offset]
            modelContext.delete(sight)
        }
    }
    
    
}

struct SightsView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var newSightName: String = ""
    
    @Bindable var destination: Destination
    
    var body: some View {
        
        ForEach(destination.sights) { sight in
            Text(sight.name)
        }
        .onDelete(perform: deleteSight)
        
        HStack {
            TextField("Add a new sight in \(destination.name)", text: $newSightName)
            
            Button("Add", action: addSight)
        }
    }
    
    func addSight() {
        guard newSightName.isEmpty == false else { return }
        
        withAnimation {
            let sight: Sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
    
    func deleteSight(at offsets: IndexSet) {
        for offset in offsets {
            let sight = destination.sights[offset]
            modelContext.delete(sight)
        }
    }
}

#Preview {
    do {
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container: ModelContainer = try ModelContainer(for: Destination.self, configurations: config)
        let example: Destination = Destination(name: "Example Destination", details: "Example details go here and will automatically expand vertically as they are edited.")
        
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
