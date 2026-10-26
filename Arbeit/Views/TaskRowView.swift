//
//  TaskRowView.swift
//  Arbeit
//
//  One row in the task list: name, assignee, due date and a check if completed.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem   // Plain value; no per-row view model needed

    /// Lays out the task's details, striking through the name when it's completed.
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.headline)
                    .strikethrough(task.completed)
                Text("Assigned to: \(task.assignedTo)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Due: \(task.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Green check for completed tasks
            if task.completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}
