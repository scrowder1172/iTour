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
    @Environment(\.dismiss) private var dismiss
    
    @State private var newSightName: String = ""
    
    @State private var photosItem: PhotosPickerItem?
    
    @State private var name: String = ""
    @State private var details: String = ""
    @State private var date: Date = Date()
    @State private var priority: Int = 2
    
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
            
            TextField("Name", text: $name)
            TextField("Details", text: $details, axis: .vertical)
            DatePicker("Date", selection: $date)
            
            Section("Priority") {
                Picker("Priority", selection: $priority) {
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
            
            Section {
                Button("Save") {
                    destination.name = name
                    destination.details = details
                    destination.date = date
                    destination.priority = priority
                    dismiss()
                }
            }
            
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", systemImage: "arrowshape.backward.circle", role: .cancel) {
                    dismiss()
                }
            }
        }
        .onChange(of: photosItem) {
            Task {
                destination.image = try? await photosItem?.loadTransferable(type: Data.self)
            }
        }
        .onAppear {
            name = destination.name
            details = destination.details
            date = destination.date
            priority = destination.priority
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
