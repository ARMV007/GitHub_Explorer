//
//  GitHubRepository.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import Foundation

struct GitHubRepository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
    let forks_count: Int
}
