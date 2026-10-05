//
//  Repository.swift
//  SwiftRepos
//
//  A single GitHub repository, decoded from the GitHub search API.
//

import Foundation

// nonisolated: Alamofire decodes JSON on a background thread, so the model's
// Codable conformance must not be tied to the main actor.
// Hashable lets the struct be used as a NavigationLink value;
// Sendable is required by current Alamofire for responseDecodable.
nonisolated struct Repository: Codable, Identifiable, Hashable, Sendable {
    let id: Int                    // Unique repo id from GitHub (used by List for Identifiable)
    let name: String               // Repo name, e.g. "Alamofire"
    let itemDescription: String?   // Optional because GitHub sometimes returns null
    let htmlURL: String            // Link to the repo's GitHub web page
    let stargazersCount: Int       // Number of stars

    // Maps JSON keys (snake_case / reserved names) to Swift property names
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case itemDescription = "description"      // avoids clash with CustomStringConvertible.description
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
    }
}
