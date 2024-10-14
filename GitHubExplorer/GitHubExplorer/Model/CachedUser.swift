//
//  CachedUser.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftData

@Model
class CachedUser {
    @Attribute(.unique) var id: Int
    
    var login: String
    var avatarURL: String
    var bio: String?
    var followers: Int
    var publicRepos: Int
    @Relationship var repositories: [CachedRepository] = []
    
    init(id: Int, login: String, avatarURL: String, bio: String?, followers: Int, publicRepos: Int) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.bio = bio
        self.followers = followers
        self.publicRepos = publicRepos
    }
}
