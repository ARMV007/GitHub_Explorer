//
//  UserSearchView.swift
//  GitHubExplorer
//
//  Created by Siri on 14/10/24.
//

import SwiftUI

struct UserSearchView: View {
    @StateObject private var viewModel = UserSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Text Field
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
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                // Profile View and Repositories
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
