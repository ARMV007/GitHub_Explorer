//
//  GitHubUser.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import Foundation

struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let bio: String?
    let followers: Int
    let public_repos: Int
}
