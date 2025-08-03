//
//  DBError.swift
//  LMessenger
//
//  Created by 김은찬 on 8/3/25.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
}
