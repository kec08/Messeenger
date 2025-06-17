//
//  AuthenticatedViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 6/9/25.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticatedViewModel: ObservableObject {
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        
        
    }
}
