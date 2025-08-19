//
//  NavigationDestination.swift
//  LMessenger
//
//  Created by 김은찬 on 8/8/25.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search(userId: String)
}
