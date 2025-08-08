//
//  ChatRoomDBRepository.swift
//  LMessenger
//
//  Created by 김은찬 on 8/8/25.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    private let db: DatabaseReference = Database.database().reference()
    
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        Future<ChatRoomObject?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).child(otherUserId).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else if let value = snapshot?.value {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value)
                        let object = try JSONDecoder().decode(ChatRoomObject.self, from: data)
                        promise(.success(object))
                    } catch {
                        promise(.failure(DBError.error(error)))
                    }
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        Future<Void, DBError> { [weak self] promise in
            do {
                let data = try JSONEncoder().encode(object)
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                self?.db.child(DBKey.ChatRooms).child(myUserId).child(object.otherUserId).setValue(json) { error, _ in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(DBError.error(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}

