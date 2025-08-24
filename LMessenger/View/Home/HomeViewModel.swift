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
        case load
        case requestContacts
        case presentMyProfileView
//        case presentView(HomeModalDestination)
        case presnOtherProfileView(String)
        case goToChat(User)
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, navigationRouter: NavigationRouter, userId: String) {
        self.container = container
        self.navigationRouter = navigationRouter
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            
            container.service.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.service.userService.loadUsers(id: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .requestContacts:
            container.service.contactService.fetchContacts()
                .flatMap { users in
                    self.container.service.userService.addUserAfterContact(users: users)
                }
                .flatMap { _ in
                    self.container.service.userService.loadUsers(id: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
                
        case .presentMyProfileView:
            modalDestination = .myProfile
            
        case let .presnOtherProfileView(userId):
            modalDestination = .otherProfile(userId)
            
        case let .goToChat(otherUser):
            //
            
            container.service.chatRoomService.createChatRoomIfNeeded(myUSerId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRoom in
                    guard let `self` = self else { return }
                    self.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId, myUserId: self.userId, otherUserId: otherUser.id))
                }.store(in: &subscriptions)
        }
    }
}

