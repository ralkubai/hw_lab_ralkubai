//
//  RepositoryRow.swift
//  SwiftRepos
//
//  One row in the list: name, description, and star count.
//

import SwiftUI

struct RepositoryRow: View {
    let repo: Repository   // Plain value type, no observation needed

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Repo name
            Text(repo.name)
                .font(.headline)

            // Description (only shown when GitHub provides one)
            if let description = repo.itemDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            // Star count with thousands separators (e.g. 12,345)
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                Text("\(repo.stargazersCount.formatted())")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
