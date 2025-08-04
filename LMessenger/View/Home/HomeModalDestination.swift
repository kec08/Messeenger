//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by 김은찬 on 8/4/25.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int {
        hashValue
    }
}
