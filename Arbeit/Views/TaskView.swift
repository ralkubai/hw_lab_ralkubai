//
//  TasksView.swift
//  Arbeit
//
//  The main list of tasks, with add (+), swipe-to-delete and tap-to-edit.
//

import SwiftUI

struct TasksView: View {
    @Environment(TasksViewModel.self) private var viewModel   // Shared view model from AppView
    @State private var showingNewTask = false                  // Controls the New Task sheet

    /// Builds the task list, toolbar, new-task sheet and the navigation to task details.
    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
                // Pushes the TaskItem value; the destination is registered below
                NavigationLink(value: task) {
                    TaskRowView(task: task)
                }
            }
            .onDelete(perform: deleteTask)   // Swipe left to delete
        }
        .navigationTitle("Arbeit")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingNewTask = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewTask) {
            NewTaskView()
                .environment(viewModel)   // Sheets don't always inherit the environment
        }
        .navigationDestination(for: TaskItem.self) { task in
            TaskDetailsView(task: task)
        }
    }

    /// Deletes the tasks at the swiped row positions.
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            viewModel.destroy(viewModel.tasks[index])
        }
    }
}
