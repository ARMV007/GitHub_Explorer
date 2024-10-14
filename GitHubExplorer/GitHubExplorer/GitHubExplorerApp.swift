//
//  GitHubExplorerApp.swift
//  GitHubExplorer
//
//  Created by Abhishek on 14/10/24.
//

import SwiftUI
import SwiftData

@main
struct GitHubExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            UserSearchView()
                .modelContainer(for: [CachedUser.self, CachedRepository.self])
        }
    }
}
