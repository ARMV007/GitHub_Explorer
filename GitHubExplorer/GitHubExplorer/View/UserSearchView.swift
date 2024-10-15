//
//  UserSearchView.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI

struct UserSearchView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel = UserSearchViewModel()
    @State var username: String = ""
    @State private var page: Int = 1
    @State private var isScrolledToBottom: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter GitHub username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    Button(action: {
                        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
                        viewModel.fetchUser(username: trimmedUsername, context: context)
                        page = 1
                    }) {
                        Text("Search")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(isUsernameValid() ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .disabled(!isUsernameValid())
                }
                .padding(.horizontal)
                .padding(.top)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }

                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if let user = viewModel.user {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading) {
                                UserProfileView(user: user) // Pass the state

                                RepositoryListView(
                                    repositories: viewModel.repositories,
                                    username: username,
                                    total_repositories: user.public_repos,
                                    page: $page,
                                    onLoadMore: {
                                        viewModel.fetchRepositories(username: username, page: page, context: context)
                                    }
                                )
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.onAppear {
                                            // Detect when scrolled to bottom
                                            let contentOffset = geometry.frame(in: .global).minY
                                            let screenHeight = UIScreen.main.bounds.height
                                            withAnimation {
                                                if contentOffset < screenHeight - 100 {
                                                    isScrolledToBottom = true
                                                } else {
                                                    isScrolledToBottom = false
                                                }
                                            }
                                        }
                                    }
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .navigationTitle("User Search")
        }
    }
    
    func isUsernameValid() -> Bool {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        let usernameRegex = "^[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,37}[a-zA-Z0-9])?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return predicate.evaluate(with: trimmedUsername)
    }
}

#Preview {
    UserSearchView()
}
