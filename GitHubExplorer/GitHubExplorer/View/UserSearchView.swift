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
                        .padding(.vertical, 5)
                        .padding(.trailing, 5)
                    
                    Text("Search")
                        .modifier(SearchButtonStyle(isEnabled: isUsernameValid()) {
                            let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
                            viewModel.fetchUser(username: trimmedUsername, context: context)
                            page = 1
                        })
                }
                .padding(.horizontal)
                .padding(.top, 16)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .font(.headline)
                }

                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                }

                if let user = viewModel.user {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                UserProfileView(user: user)
                                    .padding(.bottom, 20)

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
                            .padding(.top, 20)
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .navigationTitle("GitHub User Search")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom, 10)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()  // Dismiss the keyboard when tapping outside
            }
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
