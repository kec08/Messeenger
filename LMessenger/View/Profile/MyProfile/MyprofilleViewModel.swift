//
//  MyprofilleViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/6/25.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class MyprofilleViewModel: ObservableObject {
    
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool = false
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateUserProfileImage(pickerItem: imageSelection)
            }
        }
    }
    
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
            print(error.localizedDescription)
        }
        
    }
    
    func updateUserProfileImage(pickerItem: PhotosPickerItem?) async {
        
        guard let pickerItem else { return }
        
        do {
            let data = try await container.service.photoService.loadTransferable(from: pickerItem)
            let url = try await container.service.uploadService.uploadImage(source: .profile(userId: userId), data: data)
            try await container.service.userService.updateProfileURL(userId: userId, urlString: url.absoluteString)
            
            userInfo?.profileURL = url.absoluteString
        } catch {
            print(error.localizedDescription)
        }
    }
}
