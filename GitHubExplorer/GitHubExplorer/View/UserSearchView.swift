//
//  UserSearchView.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI

struct UserSearchView: View {
    @StateObject private var viewModel = UserSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter GitHub username", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchUser()
                        }
                    }) {
                        Text("Search")
                    }
                    .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                if let user = viewModel.user {
                    UserProfileView(user: user, repositories: viewModel.repositories)
                }
            }
            .navigationTitle("GitHub User Search")
        }
    }
}

#Preview {
    UserSearchView()
}
