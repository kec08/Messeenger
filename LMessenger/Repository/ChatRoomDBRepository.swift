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
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError>
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
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder()) // ← 여기 수정
                    .map { Array($0.values) }
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
                
            } else if value == nil {
                return Just([])
                    .setFailureType(to: DBError.self)
                    .eraseToAnyPublisher()
                
            } else {
                return Fail(error: DBError.invalidatedType)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}

