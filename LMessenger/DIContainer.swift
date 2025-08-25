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
    var navigationRoutter: NavigationRoutable
    var appearanceController: AppearanceControllerable
    
    init(service: ServiceType,
         searchDataController: DataControllable = SearchDataController(),
         navigationRoutter: NavigationRoutable = NavigationRouter(),
         appearanceController: AppearanceControllerable = AppearanceController()) {
        self.service = service
        self.searchDataController = searchDataController
        self.navigationRoutter = navigationRoutter
        self.appearanceController = appearanceController
        
        self.navigationRoutter.setObjectWillChange(objectWillChange)
        self.appearanceController.setObjectWillChange(objectWillChange)
    }
}
