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
        List {
            ForEach(repositories, id: \.name) { repo in
                VStack(alignment: .leading) {
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
                    .padding(.top, 5)
                }
            }
            
            // Load more button for pagination
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
}


//#Preview {
//    RepositoryListView(repository: GitHubRepository(id: 1, name: "Test", description: "Description", stargazers_count: 5, forks_count: 16))
//}
