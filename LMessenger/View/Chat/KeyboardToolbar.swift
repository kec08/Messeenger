//
//  KeyboardToolbar.swift
//  LMessenger
//
//  Created by 김은찬 on 8/11/25.
//

import SwiftUI

struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    private let height: CGFloat
    private let toolbarView: ToolbarView
    
    init(height: CGFloat, @ViewBuilder toolbarView: () -> ToolbarView) {
        self.height = height
        self.toolbarView = toolbarView()
    }
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .frame(width: proxy.size.width, height: proxy.size.height - height)
        }
        toolbarView
            .frame(height: height)
    }
}

extension View {
    func keyboardToobar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(height: height, toolbarView: view))
    }
}
