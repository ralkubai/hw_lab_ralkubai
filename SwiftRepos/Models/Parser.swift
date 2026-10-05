//
//  Parser.swift
//  SwiftRepos
//
//  Fetches the most-starred Swift repositories from GitHub using Alamofire.
//

import Foundation
import Alamofire

class Parser {
    // GitHub search endpoint: Swift repos sorted by stars, descending
    private let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"

    /// Requests the repo list and returns it via the completion handler.
    /// Returns an empty array if the request or decoding fails.
    func fetchRepositories(completion: @escaping ([Repository]) -> Void) {
        AF.request(url)                                       // GET request on the shared session
            .validate()                                       // Treat non-2xx status codes as failures
            .responseDecodable(of: Repositories.self) { response in   // Decode JSON straight into our model
                switch response.result {
                case .success(let container):
                    completion(container.items)               // Hand back just the array of repos
                case .failure(let error):
                    print("Error fetching repositories: \(error.localizedDescription)")
                    completion([])                            // Fail quietly with an empty list
                }
            }
    }
}
