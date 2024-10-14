//
//  CachedRepository.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftData

@Model
class CachedRepository {
    var id: Int
    var name: String
    var desc: String?
    var stargazersCount: Int
    var forksCount: Int
    @Relationship(inverse: \CachedUser.repositories) var user: CachedUser?
    
    init(id: Int, name: String, desc: String?, stargazersCount: Int, forksCount: Int, user: CachedUser) {
        self.id = id
        self.name = name
        self.desc = desc
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.user = user
    }
}

