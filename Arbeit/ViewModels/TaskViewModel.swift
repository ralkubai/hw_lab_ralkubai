//
//  TasksViewModel.swift
//  Arbeit
//
//  The single view model the views use; it forwards everything to the repository.
//

import Foundation
import Observation

@Observable
class TasksViewModel {
    /// The data source; injected so tests could pass in a fake repository.
    @ObservationIgnored private let repository: TaskRepository

    /// Creates the view model, using a real Firestore-backed repository by default.
    init(repository: TaskRepository = TaskRepository()) {
        self.repository = repository
    }

    /// The current tasks, read straight from the repository (the source of truth).
    var tasks: [TaskItem] {
        repository.tasks
    }

    /// Saves a new task to Firestore.
    func add(_ task: TaskItem) {
        repository.create(task)
    }

    /// Saves changes to an existing task.
    func update(_ task: TaskItem) {
        repository.update(task)
    }

    /// Deletes a task from Firestore.
    func destroy(_ task: TaskItem) {
        repository.delete(task)
    }
}
