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
    var photoUrl: String?
    var date: Date
    var id: String { chatId }
}
