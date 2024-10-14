//
//  NetworkHelper.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import Foundation

public class NetworkHelper {
    static let shared = NetworkHelper()
    
    private init(){}
    
    func fetchUserData(from url: String) async throws -> GitHubUser {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(GitHubUser.self, from: data)
    }
    
    func fetchRepoData(from url: String) async throws -> [GitHubRepository] {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([GitHubRepository].self, from: data)
    }
}
