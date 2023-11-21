//
//  EditDestinationView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//

import SwiftUI
import SwiftData

struct EditDestinationView: View {
    
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
            
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
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
