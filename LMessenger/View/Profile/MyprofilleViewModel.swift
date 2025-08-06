//
//  MyprofilleViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/6/25.
//

import Foundation

@MainActor
class MyprofilleViewModel: ObservableObject {
    
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool = false
    
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
    
    func updateUserDescription(_ description: String) async {
        do {
            try? await container.service.userService.updateDeescription(userId: userId, description: description)
            userInfo?.description = description
        } catch {
            
        }
        
    }
}
