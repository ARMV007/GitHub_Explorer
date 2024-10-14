//
//  UserSearchViewModel.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import Foundation
import SwiftData
import SwiftUI

class UserSearchViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var repositories: [GitHubRepository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMoreRepositories = true

    @Environment(\.modelContext) private var context

    private var currentPage = 1
    private let perPage = 5 
    
    
    func reset() {
        user = nil
        repositories = []
    }
    
    func fetchUser(username: String) {
        reset()
        isLoading = true
        errorMessage = ""
        if let cachedUser = fetchCachedUser(username: username) {
            loadCachedUser(cachedUser)
        } else {
            fetchUserFromAPI(username: username)
        }
    }
    
    func fetchUserFromAPI(username: String) {
        let userUrl = URL(string: "https://api.github.com/users/\(username)")!
        
        URLSession.shared.dataTask(with: userUrl) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        self.errorMessage = "User not found."
                        return
                    }
                }

                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let fetchedUser = try decoder.decode(GitHubUser.self, from: data)
                        self.user = fetchedUser
                        self.cacheUser(fetchedUser)
                        self.fetchRepositories(username: username, page: 1)
                    } catch {
                        self.errorMessage = "Failed to decode user data."
                    }
                }
            }
        }.resume()
    }


    func fetchRepositories(username: String, page: Int) {
        let url = URL(string: "https://api.github.com/users/\(username)/repos?page=\(page)&per_page=\(perPage)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let data = data {
                    let decoder = JSONDecoder()
                    if let fetchedRepositories = try? decoder.decode([GitHubRepository].self, from: data) {
                        self.repositories.append(contentsOf: fetchedRepositories)
                        
                        if fetchedRepositories.count < self.perPage {
                            self.hasMoreRepositories = false
                        }

                        if let cachedUser = self.fetchCachedUser(username: username) {
                            self.cacheRepositories(fetchedRepositories, for: cachedUser)
                        }
                    } else {
                        self.errorMessage = "Failed to decode repository data."
                    }
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }

    func loadMoreRepositories(username: String) {
        if !isLoading && hasMoreRepositories {
            currentPage += 1
            fetchRepositories(username: username, page: currentPage)
        }
    }

    private func fetchCachedUser(username: String) -> CachedUser? {
        let fetchRequest = FetchDescriptor<CachedUser>(predicate: #Predicate { $0.login == username })
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching cached user: \(error)")
            return nil
        }
    }
    
    private func cacheUser(_ user: GitHubUser) {
        let cachedUser = CachedUser(
            id: user.id, login: user.login,
            avatarURL: user.avatar_url,
            bio: user.bio,
            followers: user.followers,
            publicRepos: user.public_repos
        )
        context.insert(cachedUser)
        
        do {
            try context.save()
        } catch {
            print("Error saving cached user: \(error)")
        }
    }

    private func cacheRepositories(_ repositories: [GitHubRepository], for user: CachedUser) {
        repositories.forEach { repo in
            let cachedRepo = CachedRepository(
                id: repo.id, name: repo.name,
                desc: repo.description,
                stargazersCount: repo.stargazers_count,
                forksCount: repo.forks_count,
                user: user
            )
            context.insert(cachedRepo)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving repositories to cache: \(error)")
        }
    }
    
    
    private func loadCachedUser(_ cachedUser: CachedUser) {
            user = GitHubUser(
                id: cachedUser.id,
                login: cachedUser.login,
                avatar_url: cachedUser.avatarURL,
                bio: cachedUser.bio,
                followers: cachedUser.followers,
                public_repos: cachedUser.publicRepos
            )
            
            repositories = cachedUser.repositories.map { cachedRepo in
                GitHubRepository(
                    id: cachedRepo.id, name: cachedRepo.name,
                    description: cachedRepo.desc,
                    stargazers_count: cachedRepo.stargazersCount,
                    forks_count: cachedRepo.forksCount
                )
            }
            isLoading = false
        }
}
