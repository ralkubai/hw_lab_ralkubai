//
//  Repositories.swift
//  SwiftRepos
//
//  Container matching the top-level shape of the GitHub search response,
//  which wraps the repo array inside an "items" field.
//

import Foundation

// nonisolated + Sendable for the same reasons as Repository
nonisolated struct Repositories: Codable, Sendable {
    let items: [Repository]   // Matches the JSON key exactly, so no CodingKeys needed
}
