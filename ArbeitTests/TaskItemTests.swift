//
//  TaskItemTests.swift
//  ArbeitTests
//
//  Swift Testing unit tests for TaskItem's validation, equality and sorting (no Firebase needed).
//

import Testing
import Foundation
@testable import Arbeit

// @MainActor because the project defaults to main-actor isolation
@MainActor
struct TaskItemTests {

    /// One fixed date shared by all samples, so equality isn't broken by tiny Date() differences.
    private static let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

    /// Builds a sample task with sensible defaults; override only what a test cares about.
    private func sample(name: String = "Write lab",
                        assignedTo: String = "Prof H",
                        dueDate: Date = TaskItemTests.fixedDate) -> TaskItem {
        TaskItem(
            name: name,
            assignedTo: assignedTo,
            dueDate: dueDate,
            dateAdded: TaskItemTests.fixedDate,
            completed: false
        )
    }

    /// An empty name must fail validation.
    @Test func validationRejectsEmptyName() {
        #expect(TaskItem.isValid(name: "", assignedTo: "someone") == false)
    }

    /// An empty assignee must fail validation.
    @Test func validationRejectsEmptyAssignee() {
        #expect(TaskItem.isValid(name: "something", assignedTo: "") == false)
    }

    /// Both fields filled in must pass validation.
    @Test func validationAcceptsBothPresent() {
        #expect(TaskItem.isValid(name: "something", assignedTo: "someone") == true)
    }

    /// Equality looks only at name, assignee and due date, not id or completion.
    @Test func equalityIgnoresIdAndCompletion() {
        var a = sample()
        var b = sample()
        a.id = "abc"
        b.id = "xyz"
        b.completed = true   // completed is not part of `==`
        #expect(a == b)      // same name, assignedTo, dueDate
    }

    /// Sorting an array of tasks orders them alphabetically by name.
    @Test func sortsByName() {
        let apple = sample(name: "Apple")
        let banana = sample(name: "Banana")
        let cherry = sample(name: "Cherry")
        let sorted = [cherry, apple, banana].sorted()
        #expect(sorted.map(\.name) == ["Apple", "Banana", "Cherry"])
    }
}
