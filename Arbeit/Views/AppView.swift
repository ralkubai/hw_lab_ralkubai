//
//  AppView.swift
//  Arbeit
//
//  Root view: owns the view model and sets up the Tasks / New Task tabs.
//

import SwiftUI

struct AppView: View {
    /// The single view model for the app, owned here and shared through the environment.
    @State private var tasksViewModel = TasksViewModel()

    /// Two tabs, each with its own NavigationStack so each gets its own title bar.
    var body: some View {
        TabView {
            NavigationStack {
                TasksView()
            }
            .tabItem {
                Image(systemName: "checkmark.rectangle.stack.fill")
                Text("Tasks")
            }

            NavigationStack {
                NewTaskView()
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
                Text("New Task")
            }
        }
        .environment(tasksViewModel)   // Makes the view model available to every view below
    }
}
