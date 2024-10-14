//
//  RepositoryRowView.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI

struct RepositoryRowView: View {
    let repository: GitHubRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
            
            Text(repository.description ?? "No description")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("⭐️ \(repository.stargazers_count)")
                Text("🍴 \(repository.forks_count)")
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.vertical, 4)
    }
}


#Preview {
    RepositoryRowView(repository: GitHubRepository(id: 1, name: "Test", description: "Description", stargazers_count: 5, forks_count: 16))
}
