//
//  Untitled.swift
//  GitHubExplorer
//
//  Created by Abhishek on 15/10/24.
//

import XCTest
@testable import GitHubExplorer

final class UserSearchViewModelTests: XCTestCase {

    var viewModel: UserSearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = UserSearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchUser() {
        let mockUsername = "testuser"
        let mockUser = GitHubUser(
            id: 1,
            login: mockUsername,
            avatar_url: "https://example.com/avatar.png",
            bio: "Test User Bio",
            followers: 10,
            public_repos: 2
        )
        viewModel.user = mockUser
        XCTAssertEqual(viewModel.user?.login, mockUsername)
        XCTAssertEqual(viewModel.user?.bio, "Test User Bio")
        XCTAssertEqual(viewModel.user?.followers, 10)
        XCTAssertEqual(viewModel.user?.public_repos, 2)
    }
    
    func testReset() {
        viewModel.user = GitHubUser(id: 1, login: "testuser", avatar_url: "", bio: "Test", followers: 10, public_repos: 2)
        viewModel.repositories = [GitHubRepository(id: 1, name: "Repo1", description: "Test Repo", stargazers_count: 5, forks_count: 2)]
        viewModel.reset()
        XCTAssertNil(viewModel.user)
        XCTAssertEqual(viewModel.repositories.count, 0)
    }
    
    func testLoadingState() {
        XCTAssertFalse(viewModel.isLoading)
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoading)
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading)
    }
}
