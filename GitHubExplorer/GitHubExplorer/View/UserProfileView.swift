//
//  UserProfileView.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI

struct UserProfileView: View  {
    let user: GitHubUser
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            
            VStack {
                ImageLoaderView(urlStirng: user.avatar_url)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text(user.login)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            
            if let bio = user.bio {
                Text(bio)
                    .font(.body)
            }
            
            HStack {
                Text("Followers: \(user.followers)")
                Spacer()
                Text("Repositories: \(user.public_repos)")
            }
            .font(.callout)
        }
        .padding()
    }
}

#Preview {
    UserProfileView(user: GitHubUser(id: 122, login: "@ARMV", avatar_url: Constants.randomImage, bio: "bio", followers: 7, public_repos: 0))
}
