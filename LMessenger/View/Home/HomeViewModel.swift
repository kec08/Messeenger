//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/2/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
        case requestContacts
        case presentView(HomeModalDestination)
        case goToChat(User)
    }

    @Published var phase: Phase = .notRequested
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var navigationRoutter: NavigationRoutable & ObservableObjectSettable

    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
        self.navigationRoutter = container.navigationRouter
    }

    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            
            container.service.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .flatMap { [weak self] user -> AnyPublisher<[User], ServiceError> in
                    guard let `self` = self else { return Empty().eraseToAnyPublisher() }
                    return self.container.service.userService.loadUsers(id: user.id)
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
                .flatMap { [weak self] users -> AnyPublisher<Void, ServiceError> in
                    guard let `self` = self else { return Empty().eraseToAnyPublisher() }
                    return self.container.service.userService.addUserAfterContact(users: users)
                }
                .flatMap { [weak self] _ -> AnyPublisher<[User], ServiceError> in
                    guard let `self` = self else { return Empty().eraseToAnyPublisher() }
                    return self.container.service.userService.loadUsers(id: self.userId)
                }
                .receive(on: DispatchQueue.main)
                .sink { completion in
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case let .presentView(destination):
            modalDestination = destination
            
        case let .goToChat(otherUser):
            container.service.chatRoomService
                .createChatRoomIfNeeded(myUSerId: userId,
                                        otherUserId: otherUser.id,
                                        otherUserName: otherUser.name)
                .sink { completion in
                } receiveValue: { [weak self] chatRoom in
                    guard let self = self else { return }
                    
                    self.navigationRoutter.push(to: .chat(
                        chatRoomId: chatRoom.chatRoomId,
                        myUserId: self.userId,
                        otherUserId: otherUser.id
                    ))
                }
                .store(in: &subscriptions)

        }
    }
}
