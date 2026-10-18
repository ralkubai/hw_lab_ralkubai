//
//  SimpleContactsApp.swift
//  SimpleContacts
//
//  App entry point; sets up the SwiftData container.
//

import SwiftUI
import SwiftData

@main
struct SimpleContactsApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()   // Root view with the main navigation
        }
        // Creates the persistence container for Person and injects
        // its model context into the SwiftUI environment
        .modelContainer(for: Person.self)
    }
}
