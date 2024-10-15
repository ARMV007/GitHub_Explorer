//
//  UserSearchViewTests.swift
//  GitHubExplorerTests
//
//  Created by Abhishek on 15/10/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import GitHubExplorer
import SwiftData


final class UserSearchViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testTextFieldExists() throws {
        let view = UserSearchView()
        let textField = try view.inspect().find(ViewType.TextField.self)
        XCTAssertEqual(try textField.input(), "")
    }
    
    func testSearchButtonExists() throws {
        let view = UserSearchView()
        let button = try view.inspect().find(button: "Search")
        XCTAssertNotNil(button)
    }
}
