//
//  TaskRepository.swift
//  Arbeit
//
//  Talks to Firestore: keeps `tasks` in sync in real time and performs CRUD operations.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class TaskRepository {
    // Not observed: these are implementation details that shouldn't trigger view updates.
    @ObservationIgnored private let path: String = "tasks"                   // Firestore collection name
    @ObservationIgnored private let store = Firestore.firestore()            // Firestore handle
    @ObservationIgnored private var listener: ListenerRegistration?          // Live listener, removed in deinit

    /// All tasks currently in Firestore. Views re-render when this changes.
    var tasks: [TaskItem] = []

    /// Starts listening to Firestore as soon as the repository is created.
    init() {
        self.get()
    }

    /// Stops the Firestore listener when the repository goes away, so it doesn't leak.
    deinit {
        listener?.remove()
    }

    /// Attaches a real-time listener to the "tasks" collection and decodes every document into a TaskItem.
    func get() {
        listener = store.collection(path)
            .addSnapshotListener { [weak self] querySnapshot, error in   // [weak self] avoids a retain cycle
                guard let self = self else { return }
                if let error = error {
                    print("Error getting tasks: \(error.localizedDescription)")
                    return
                }
                // Skip any document that fails to decode instead of crashing.
                self.tasks = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TaskItem.self)
                } ?? []
            }
    }

    // MARK: CRUD methods

    /// Adds a new task as a new Firestore document (Firestore generates its ID).
    func create(_ task: TaskItem) {
        do {
            _ = try store.collection(path).addDocument(from: task)
        } catch {
            print("Error creating task: \(error.localizedDescription)")
        }
    }

    /// Overwrites an existing task's document with the updated values.
    func update(_ task: TaskItem) {
        guard let taskId = task.id else {
            print("Error updating task: Task ID is missing")
            return
        }
        do {
            try store.collection(path).document(taskId).setData(from: task)
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }

    /// Deletes a task's document from Firestore.
    func delete(_ task: TaskItem) {
        guard let taskId = task.id else {
            print("Error deleting task: Task ID is missing")
            return
        }
        store.collection(path).document(taskId).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
}
