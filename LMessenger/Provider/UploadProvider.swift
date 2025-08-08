//
//  UploadProvider.swift
//  LMessenger
//
//  Created by 김은찬 on 8/7/25.
//

import Foundation
import FirebaseStorage

protocol UploadProviderType {
    func upload(path:String , data: Data, fileName: String) async throws -> URL
}

class UploadProvider: UploadProviderType {
    
    let storageRef = Storage.storage().reference()
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = self.storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
}
