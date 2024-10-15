//
//  RepositoryListView.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI

struct RepositoryListView: View {
    let repositories: [GitHubRepository]
    let username: String
    let total_repositories: Int
    @Binding var page: Int
    let onLoadMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Repositories (\(repositories.count)/\(total_repositories))")
                .font(.headline)
                .padding(.bottom, 10)
            
            LazyVStack(alignment: .leading) {
                ForEach(repositories, id: \.name) { repo in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(repo.name)
                            .font(.headline)
                        
                        if let description = repo.description {
                            Text(description)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text("⭐️ \(repo.stargazers_count)")
                            Spacer()
                            Text("🍴 \(repo.forks_count)")
                        }
                        .font(.caption)
                    }
                    .padding(.vertical)
                    Divider()
                }

                // Load More Button for Pagination
                if repositories.count < total_repositories {
                    Button(action: {
                        page += 1
                        onLoadMore()
                    }) {
                        Text("Load More")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    @Previewable @State var currentPage = 1
    let mockRepositories: [GitHubRepository] = [
        GitHubRepository(id: 1, name: "AwesomeRepo1", description: "This is an awesome repository", stargazers_count: 150, forks_count: 30),
        GitHubRepository(id: 2, name: "AwesomeRepo2", description: "Another amazing repository", stargazers_count: 200, forks_count: 50),
        GitHubRepository(id: 3, name: "CoolRepo", description: "Cool repo with great features", stargazers_count: 120, forks_count: 25),
        GitHubRepository(id: 4, name: "OldRepo", description: nil, stargazers_count: 75, forks_count: 10)
    ]
    RepositoryListView(
        repositories: mockRepositories,
        username: "mockUser",
        total_repositories: 4,
        page: $currentPage,
        onLoadMore: {
            print("Loading more repositories...")
            currentPage += 1
        }
    )
}
