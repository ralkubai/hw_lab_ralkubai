//
//  Person.swift
//  SimpleContacts
//
//  SwiftData model for a single contact.
//

import Foundation
import SwiftData

// @Model turns this class into a persistent SwiftData model
// (right-click the macro → Expand Macro to see the generated code).
@Model
class Person {
    var name: String      // Contact's full name
    var email: String     // Contact's email address
    var details: String   // Free-form notes about the contact

    // Stored outside the SQLite database (in a separate file) because image data is large
    @Attribute(.externalStorage) var photo: Data?

    // photo defaults to nil so existing callers (and tests) don't need to pass it
    init(name: String, email: String, details: String, photo: Data? = nil) {
        self.name = name
        self.email = email
        self.details = details
        self.photo = photo
    }
}
