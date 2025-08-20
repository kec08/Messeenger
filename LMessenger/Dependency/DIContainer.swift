//
//  DIContainer.swift
//  LMessenger
//
//  Created by 김은찬 on 6/9/25.
//

import Foundation

class DIContainer: ObservableObject {
    var service: ServiceType
    let navigationRouter: NavigationRouter
    
    init(service: ServiceType) {
        self.service = service
        self.navigationRouter = NavigationRouter()
    }
}
