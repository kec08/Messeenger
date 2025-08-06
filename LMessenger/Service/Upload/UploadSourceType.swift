//
//  UploadSourceType.swift
//  LMessenger
//
//  Created by 김은찬 on 8/7/25.
//

import Foundation

enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    var path: String {
        switch self {
        case let .chat(chatRoomId): // Chat/chatRoomId
            return "\(DBKey.Chats)/\(chatRoomId)"
        case let .profile(userId): //Users/UserId/
            return "\(DBKey.Users)/\(userId)"
        }
    }
}
