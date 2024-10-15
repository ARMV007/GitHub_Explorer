//
//  SearchButtonStyle.swift
//  GitHubExplorer
//
//  Created by Abhishek on 15/10/24.
//

import SwiftUI

struct SearchButtonStyle: ViewModifier {
    var isEnabled: Bool
    var action: () -> Void

    func body(content: Content) -> some View {
        Button(action: {
            UIApplication.shared.endEditing()
            action()
        }) {
            content
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isEnabled ? .blue : .gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(radius: 5)
        }
        .disabled(!isEnabled)
    }
}

