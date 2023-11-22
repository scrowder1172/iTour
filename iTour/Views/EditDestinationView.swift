//
//  EditDestinationView.swift
//  iTour
//
//  Created by SCOTT CROWDER on 11/21/23.
//
//  make modelContext a private var to avoid issues with init

import SwiftUI
import SwiftData
import PhotosUI

struct EditDestinationView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var newSightName: String = ""
    
    @State private var photosItem: PhotosPickerItem?
    
    @Bindable var destination: Destination
    
    var sortedSights: [Sight] {
        destination.sights.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        Form {
            
            Section{
                if let imageData = destination.image {
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                PhotosPicker("Attach a photo", selection: $photosItem, matching: .images)
            }
            
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
                ForEach(sortedSights) { sight in
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
        .onChange(of: photosItem) {
            Task {
                destination.image = try? await photosItem?.loadTransferable(type: Data.self)
            }
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
            let sight = sortedSights[offset]
            modelContext.delete(sight)
        }
        
        // no longer needed due to inverse relationship
        //destination.sights.remove(atOffsets: offsets)
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
