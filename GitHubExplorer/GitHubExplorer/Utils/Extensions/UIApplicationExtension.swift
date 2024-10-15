//
//  UIApplicationExtension.swift
//  GitHubExplorer
//
//  Created by Abhishek on 15/10/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
