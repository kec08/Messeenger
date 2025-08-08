//
//  Constant.swift
//  LMessenger
//
//  Created by 김은찬 on 8/3/25.
//

import Foundation

typealias DBKey = Constant.DBKey

enum Constant { }
    
extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}

