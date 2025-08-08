//
//  OtherProfileViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/8/25.
//

import Foundation

@MainActor
class OtherProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    
    private var userId: String
    
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.service.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
}
