//
//  DIContainer.swift
//  LMessenger
//
//  Created by 김은찬 on 6/9/25.
//

import Foundation

class DIContainer: ObservableObject {
    var service: ServiceType
    var searchDataController: DataControllable
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    var appearanceController: AppearanceControllerable & ObservableObjectSettable
    
    init(service: ServiceType,
         searchDataController: DataControllable = SearchDataController(),
         navigationRoutter: NavigationRoutable & ObservableObjectSettable = NavigationRouter(),
         appearanceController: AppearanceControllerable & ObservableObjectSettable = AppearanceController()) {
        self.service = service
        self.searchDataController = searchDataController
        self.navigationRouter = navigationRoutter
        self.appearanceController = appearanceController
        
        self.navigationRouter.setObjectWillChange(objectWillChange)
        self.appearanceController.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(service: StubServices())
    }
}
