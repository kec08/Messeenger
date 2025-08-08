//
//  NavigationRouter.swift
//  LMessenger
//
//  Created by 김은찬 on 8/8/25.
//

import Foundation

class NavigationRouter: ObservableObject {
    
    @Published var desctinations: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        desctinations.append(view)
    }
    
    func pop() {
        desctinations.popLast()
    }
    
    func popToRootView() {
        desctinations = []
    }
}
