//
//  PeopleView.swift
//  SimpleContacts
//
//  Lists contacts from SwiftData, with search filtering, sorting, and swipe-to-delete.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) var modelContext   // Used to delete people
    @Query var people: [Person]                     // Live query of stored people

    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    // Show a placeholder so blank (just-added) contacts are still tappable
                    Text(person.name.isEmpty ? "New Person" : person.name)
                        .foregroundStyle(person.name.isEmpty ? .secondary : .primary)
                }
            }
            .onDelete(perform: deletePeople)   // Enables left-swipe to delete
        }
    }

    /// Builds the query with a search filter and sort order.
    /// `_people` sets the @Query wrapper's storage itself (not its value).
    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        _people = Query(filter: #Predicate { person in
            if searchString.isEmpty {
                true   // No search text: include everyone
            } else {
                person.name.localizedStandardContains(searchString)   // Case/diacritic-insensitive match
            }
        }, sort: sortOrder)
    }

    /// Deletes the people at the swiped row positions.
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}

#Preview {
    // In-memory container with sample data for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    container.mainContext.insert(Person(name: "Alex Heimann", email: "alex@example.com", details: ""))
    container.mainContext.insert(Person(name: "Tim Daigle", email: "tim@example.com", details: ""))

    return NavigationStack {
        PeopleView(searchString: "")
    }
    .modelContainer(container)
}
