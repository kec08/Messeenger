//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/2/25.
//

import Foundation
import Combine

class HmoeViewModel: ObservableObject {
    
    enum Action {
        case getUser
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    
    private var userId: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .getUser:
            container.service.userService.getUser(userId: userId)
                .sink { completion in
                    // TODO:
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }
        }
    }
}

