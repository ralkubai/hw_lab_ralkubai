//
//  ContentView.swift
//  SwiftRepos
//
//  Main screen: searchable list of Swift repos; tapping a row opens its GitHub page.
//

import SwiftUI

struct ContentView: View {
    // @State is the correct way to own an @Observable view model in a view
    @State private var viewModel = RepositoryViewModel()

    var body: some View {
        NavigationStack {
            // List shows the filtered repos; each row navigates by value
            List(viewModel.filteredRepos) { repo in
                NavigationLink(value: repo) {
                    RepositoryRow(repo: repo)
                }
            }
            .navigationTitle("Swift Repos")
            // System search field, two-way bound to the view model's searchText
            .searchable(text: Bindable(viewModel).searchText, prompt: "Search repos")
            // Destination for a tapped repo: its GitHub page in a web view
            .navigationDestination(for: Repository.self) { repo in
                if let url = URL(string: repo.htmlURL) {
                    WebView(url: url)
                        .navigationTitle(repo.name)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            // Fetch only once, so swiping back from a web view doesn't reload
            .onAppear {
                if viewModel.repos.isEmpty {
                    viewModel.loadRepositories()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
