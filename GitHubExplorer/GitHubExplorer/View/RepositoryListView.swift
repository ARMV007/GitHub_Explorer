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


//#Preview {
//    RepositoryListView(repository: GitHubRepository(id: 1, name: "Test", description: "Description", stargazers_count: 5, forks_count: 16))
//}
