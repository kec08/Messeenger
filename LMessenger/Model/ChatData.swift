//
//  ChatData.swift
//  LMessenger
//
//  Created by 김은찬 on 8/11/25.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    var id: String { dateStr }
}


