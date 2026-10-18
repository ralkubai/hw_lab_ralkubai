//
//  AppView.swift
//  SimpleContacts
//
//  Sets up the main navigation, toolbar (sort + add), and search bar.
//

import SwiftUI
import SwiftData

struct AppView: View {
    @Environment(\.modelContext) var modelContext   // Used to insert new people
    @State private var path = [Person]()            // Navigation stack of people being edited
    @State private var searchText = ""              // Bound to the search bar
    @State private var sortOrder = [SortDescriptor(\Person.name)]   // Default: A-Z by name

    var body: some View {
        NavigationStack(path: $path) {
            // The list itself, filtered by search text and sorted by sortOrder
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("My Contacts")
                // Tapping a row (or adding a person) pushes the edit screen
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person)
                }
                .toolbar {
                    // Sort menu: ascending or descending by name
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.name)])

                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }

                    // Add a new blank contact
                    Button("Add Person", systemImage: "plus", action: addPerson)
                }
                .searchable(text: $searchText)
        }
    }

    /// Creates a blank person, saves it to the context, and opens it for editing.
    func addPerson() {
        let person = Person(name: "", email: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }
}

#Preview {
    // In-memory container with sample data so the preview doesn't touch real storage
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    container.mainContext.insert(Person(name: "Alex Heimann", email: "alex@example.com", details: ""))
    container.mainContext.insert(Person(name: "Tim Daigle", email: "tim@example.com", details: ""))

    return AppView()
        .modelContainer(container)
}
