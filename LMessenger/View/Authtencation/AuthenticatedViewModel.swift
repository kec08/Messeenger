//
//  AuthenticatedViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 6/9/25.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticatedViewModel: ObservableObject {
    
    enum Action {
        case checkAutthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case requestPushNotification
        case setPushToken
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading = false
    
    var userId: String?
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        
    }
    
    func send(action: Action) {
        switch action {
        case .checkAutthenticationState:
            if let userId = container.service.authService.checkAutthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
            
        //MARK: google 로그인 액션
        case .googleLogin:
            isLoading = true
            
            container.service.authService.signInWithGoogle()
            // TODO: db 추가
                .flatMap { user in
                    self.container.service.userService.addUser(user)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] user in
                    self?.isLoading = false
                    self?.userId = user.id
                    self? .authenticationState = .authenticated
                }.store(in: &subscriptions)
            
            
        case let .appleLogin(request):
            let nonce = container.service.authService.handleSignInwithAppleRequest(request)
            currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.service.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
                    .flatMap { user in
                        self.container.service.userService.addUser(user)
                    }
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                    }.store(in: &subscriptions)
                
            } else if case let .failure(error) = result {
                isLoading = false
                print(error.localizedDescription)
            }
            
        case .requestPushNotification:
            container.service.pushNotificationService.requestAuthorization { [weak self] granted in
                guard granted else { return }
                self?.send(action: .setPushToken)
            }
        
        case .setPushToken:
            container.service.pushNotificationService.fcmToken
                .compactMap { $0 }
                .flatMap { [weak self] fcmToken -> AnyPublisher<Void, Never> in
                    guard let `self` = self, let userId = self.userId else { return Empty().eraseToAnyPublisher() }
                    return self.container.service.userService.updateFCMToken(userId: userId, fcmToken: fcmToken)
                        .replaceError(with: ())
                        .eraseToAnyPublisher()
                }
                .sink { _ in
                }.store(in: &subscriptions)
            
            
        case .logout:
            container.service.authService.logout()
                .sink { Comparator in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
        }
    }
}
