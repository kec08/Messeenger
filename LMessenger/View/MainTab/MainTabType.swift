//
//  MainTabType.swift
//  LMessenger
//
//  Created by 김은찬 on 8/2/25.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case chat
    case phone

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "채팅"
        case .phone:
            return "전화"
        }
    }

    func imageName(selected: Bool) -> String {
        selected ? "\(self.rawValue)_fill" : self.rawValue
    }
}

