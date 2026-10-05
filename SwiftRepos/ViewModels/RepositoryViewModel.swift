//
//  RepositoryViewModel.swift
//  SwiftRepos
//
//  Holds the repo list and search text, and exposes a filtered list to the UI.
//

import Foundation
import Observation

@Observable
class RepositoryViewModel {
    var repos: [Repository] = []   // Full list loaded from GitHub
    var searchText: String = ""    // Bound to the search field

    /// Derived state: repos whose name contains the search text (case-insensitive).
    /// Computed on demand so it can never get out of sync with `repos`.
    var filteredRepos: [Repository] {
        guard !searchText.isEmpty else { return repos }
        return repos.filter { repo in
            repo.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    // The parser is an implementation detail, so it shouldn't trigger view updates
    @ObservationIgnored private let parser = Parser()

    /// Loads repos from the network and stores them.
    func loadRepositories() {
        // [weak self] avoids a retain cycle if the view model goes away mid-request
        parser.fetchRepositories { [weak self] repos in
            self?.repos = repos
        }
    }
}
