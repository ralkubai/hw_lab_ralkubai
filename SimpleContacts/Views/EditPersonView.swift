//
//  EditPersonView.swift
//  SimpleContacts
//
//  Form for editing a contact's photo, information, and details.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPersonView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person                    // Two-way bindings to the model's properties
    @State private var selectedItem: PhotosPickerItem?   // Photo chosen in the picker

    var body: some View {
        Form {
            // Photo first, since it's the first thing you want to see
            Section("Photo") {
                // Show the saved photo, if there is one
                if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }

                // Opens the system photo picker (images only)
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }

            Section("Information") {
                TextField("Name", text: $person.name)
                    .textContentType(.name)           // Suggests names from the system
                TextField("Email", text: $person.email)
                    .textContentType(.emailAddress)   // Suggests email addresses
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Details") {
                TextField("Details", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        // When a new photo is picked, load it into the model
        .onChange(of: selectedItem) { _, _ in loadPhoto() }
    }

    /// Loads the picked photo's data asynchronously and saves it on the person.
    func loadPhoto() {
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

#Preview {
    // In-memory container and a single sample person to bind to
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    let person = Person(name: "Alex Heimann", email: "alex@example.com", details: "Friend")
    container.mainContext.insert(person)

    return NavigationStack {
        EditPersonView(person: person)
    }
    .modelContainer(container)
}
