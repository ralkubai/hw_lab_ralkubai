//
//  TaskRowView.swift
//  Arbeit
//
//  One row in the task list: name, assignee, due date and a check if completed.
//

import SwiftUI

struct TaskRowView: View, Equatable {
    let task: TaskItem   // Plain value; no per-row view model needed

    /// Tells SwiftUI when this row must redraw.
    /// TaskItem's own == ignores `completed` and `id` (by design, for the model),
    /// so without this SwiftUI saw a completed/uncompleted toggle as "no change"
    /// and kept showing the old row. Here we compare those fields explicitly.
    static func == (lhs: TaskRowView, rhs: TaskRowView) -> Bool {
        lhs.task == rhs.task
            && lhs.task.completed == rhs.task.completed
            && lhs.task.id == rhs.task.id
    }

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
