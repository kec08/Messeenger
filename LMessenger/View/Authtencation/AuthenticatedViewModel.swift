//
//  AuthenticatedViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 6/9/25.
//

import Foundation
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticatedViewModel: ObservableObject {
    
    enum Action {
        case googleLogin
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        
    }
    
    func send(action: Action) {
        switch action {
        //MARK: google 로그인 액션
        case .googleLogin:
            container.service.authService.signInWithGoogle()
                .sink { container in
                    // TODO:
                } receiveValue: { [weak self] user in
                    self?.userId = user.id
                }.store(in: &subscriptions)
        }
    }
}
