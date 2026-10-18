//
//  PersonTests.swift
//  SimpleContactsTests
//
//  Swift Testing unit tests for the Person model using an in-memory SwiftData store.
//

import Testing
import Foundation   // Needed for SortDescriptor and #Predicate
import SwiftData
@testable import SimpleContacts

// @MainActor because the project defaults to main-actor isolation
@MainActor
struct PersonTests {

    // Builds a fresh in-memory container per test (never touches the real SQLite file)
    private func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Person.self, configurations: config)
    }

    // init stores the values and leaves photo nil
    @Test func personInitializesWithDefaults() {
        let person = Person(name: "Alex Heimann", email: "alex@example.com", details: "Friend")
        #expect(person.name == "Alex Heimann")
        #expect(person.email == "alex@example.com")
        #expect(person.details == "Friend")
        #expect(person.photo == nil)
    }

    // Inserting and saving makes the person fetchable
    @Test func insertingPersistsInContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(name: "An Heimann", email: "an@example.com", details: "Wife")
        context.insert(person)
        try context.save()

        let descriptor = FetchDescriptor<Person>()
        let all = try context.fetch(descriptor)
        #expect(all.count == 1)
        #expect(all.first?.name == "An Heimann")
    }

    // Deleting removes the person from the store
    @Test func deleteRemovesFromContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(name: "Tim Daigle", email: "tim@example.com", details: "")
        context.insert(person)
        try context.save()

        context.delete(person)
        try context.save()

        let all = try context.fetch(FetchDescriptor<Person>())
        #expect(all.isEmpty)
    }

    // Sorting by name returns people alphabetically
    @Test func sortDescriptorOrdersByName() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        context.insert(Person(name: "Tom Brady", email: "", details: ""))
        context.insert(Person(name: "Alex Heimann", email: "", details: ""))
        context.insert(Person(name: "Tim Daigle", email: "", details: ""))
        try context.save()

        var descriptor = FetchDescriptor<Person>()
        descriptor.sortBy = [SortDescriptor(\.name)]
        let sorted = try context.fetch(descriptor)

        #expect(sorted.map(\.name) == ["Alex Heimann", "Tim Daigle", "Tom Brady"])
    }

    // The search predicate matches part of a name, ignoring case
    @Test func searchPredicateMatchesSubstring() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        context.insert(Person(name: "Alex Heimann", email: "", details: ""))
        context.insert(Person(name: "An Heimann", email: "", details: ""))
        context.insert(Person(name: "Tom Brady", email: "", details: ""))
        try context.save()

        let needle = "heim"
        let descriptor = FetchDescriptor<Person>(
            predicate: #Predicate { $0.name.localizedStandardContains(needle) }
        )
        let matches = try context.fetch(descriptor)
        #expect(matches.count == 2)
        #expect(matches.allSatisfy { $0.name.localizedStandardContains("heim") })
    }
}
