//
//  UserSearchViewModel.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import Foundation
import Combine

class UserSearchViewModel: ObservableObject {
    // Published properties to notify the view
    @Published var searchText: String = ""
    @Published var user: GitHubUser?
    @Published var repositories: [GitHubRepository] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let baseURL = "https://api.github.com/users/"
    
    // Function to fetch user data
    func fetchUser() async {
        guard !searchText.isEmpty else { return }
        let userURL = baseURL + searchText
        
        DispatchQueue.main.async { [self] in
            isLoading = true
        }
       
        do {
            let user = try await NetworkHelper.shared.fetchUserData(from: userURL)
            DispatchQueue.main.async {
                self.user = user
                self.errorMessage = nil
            }
            await fetchRepositories(for: user.login)
        } catch {
            DispatchQueue.main.async {
                self.user = nil
                self.repositories = []
                self.errorMessage = "User not found"
            }
        }
    }
    
    // Function to fetch repositories data
    private func fetchRepositories(for username: String) async {
        let reposURL = baseURL + username + "/repos"
        
        do {
            let repositories = try await NetworkHelper.shared.fetchRepoData(from: reposURL)
            DispatchQueue.main.async { [self] in
                self.repositories = repositories
                isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load repositories"
            }
        }
    }
}

