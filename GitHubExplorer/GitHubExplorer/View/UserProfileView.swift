//
//  UserProfileView.swift
//  GitHubExplorer
//
//  Created by Siri on 14/10/24.
//

import SwiftUI

struct UserProfileView: View {
    let user: GitHubUser
    let repositories: [GitHubRepository]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Text(user.login)
                    .font(.title)
                    .bold()
                
                Text(user.bio ?? "No bio available")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Text("Followers: \(user.followers)")
                    Text("Repos: \(user.public_repos)")
                }
                
                // List of repositories
                if !repositories.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Repositories")
                            .font(.headline)
                        
                        ForEach(repositories) { repo in
                            RepositoryRowView(repository: repo)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    UserProfileView(user: GitHubUser(id: 122, login: "@ARMV", avatar_url: Constants.randomImage, bio: "bio", followers: 7, public_repos: 0), repositories: [])
}
