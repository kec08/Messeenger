//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/2/25.
//

import Foundation

class HmoeViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2]
}
