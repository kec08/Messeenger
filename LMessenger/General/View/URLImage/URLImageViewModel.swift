//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by 김은찬 on 8/7/25.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
    
    var ldadingOrSuccess: Bool {
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var loading: Bool = false
    private var urlString: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, urlStirng: String) {
        self.container = container
        self.urlString = urlStirng
    }
    
    func start() {
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.service.imageCacheService.image(forKey: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }.store(in: &subscriptions)
    }
}
