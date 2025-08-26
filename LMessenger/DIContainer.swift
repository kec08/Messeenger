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
    var navigationRoutter: NavigationRoutable & ObservableObjectSettable
    var appearanceController: AppearanceControllerable & ObservableObjectSettable
    
    init(service: ServiceType,
         searchDataController: DataControllable = SearchDataController(),
         navigationRoutter: NavigationRoutable & ObservableObjectSettable = NavigationRouter(),
         appearanceController: AppearanceControllerable & ObservableObjectSettable = AppearanceController()) {
        self.service = service
        self.searchDataController = searchDataController
        self.navigationRoutter = navigationRoutter
        self.appearanceController = appearanceController
        
        self.navigationRoutter.setObjectWillChange(objectWillChange)
        self.appearanceController.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(service: StubServices())
    }
}
