//
//  NavigationRoutingView.swift
//  LMessenger
//
//  Created by 김은찬 on 8/10/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .chat:
            ChatView()
        case .search:
            SearchView()
        }
    }
}


struct NavigationRoutingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationRoutingView(destination: .chat)
    }
}



