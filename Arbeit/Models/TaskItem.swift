//
//  TaskItem.swift
//  Arbeit
//
//  A single task stored as a document in the Firestore "tasks" collection.
//

import Foundation
import FirebaseFirestore

// Named TaskItem (not Task) to avoid clashing with Swift concurrency's Task type.
struct TaskItem: Identifiable, Comparable, Codable, Hashable {
    // MARK: Fields

    /// Firestore document ID. Nil for new tasks until Firestore assigns one.
    @DocumentID var id: String?
    var name: String          // What needs to be done
    var assignedTo: String    // Who is responsible
    var dueDate: Date         // When it's due
    var dateAdded: Date       // When it was created
    var completed: Bool       // Whether it's done

    // MARK: Codable

    /// Maps Swift properties to Firestore field names (they match exactly here).
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case assignedTo
        case dueDate
        case dateAdded
        case completed
    }

    // MARK: Comparable

    /// Two tasks are equal when name, assignee and due date match (id and completion are ignored).
    static func ==(lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.name == rhs.name && lhs.assignedTo == rhs.assignedTo && lhs.dueDate == rhs.dueDate
    }

    /// Orders tasks alphabetically by name, so `.sorted()` works on [TaskItem].
    static func <(lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.name < rhs.name
    }

    // MARK: Hashable

    /// Hashes the same fields `==` compares, so equal tasks always produce equal hashes.
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(assignedTo)
        hasher.combine(dueDate)
    }
}

// MARK: - Validation

extension TaskItem {
    /// Returns true only when both the task name and the assignee are filled in.
    static func isValid(name: String, assignedTo: String) -> Bool {
        return !name.isEmpty && !assignedTo.isEmpty
    }
}
