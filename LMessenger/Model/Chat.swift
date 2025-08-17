//
//  Chat.swift
//  LMessenger
//
//  Created by 김은찬 on 8/11/25.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    var id: String { chatId }
    
    var lastMessage: String {
        if let message {
            return message
        } else if let _ = photoURL {
            return "사진"
        } else {
            return "내용없음"
        }
    }
}

extension Chat {
    func toObject() -> ChatObject {
        .init(chatId: chatId,
              userId: userId,
              message: message,
              photoURL: photoURL,
              date: date.timeIntervalSince1970)
    }
}
