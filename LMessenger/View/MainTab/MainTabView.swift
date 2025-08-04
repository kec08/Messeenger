//
//  MainTabView.swift
//  LMessenger
//
//  Created by 김은찬 on 6/17/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticatedViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab  {
                    case .home:
                        HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
    }
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView()
    }
}

struct MainTableView_Previews: PreviewProvider {
    static let containers = DIContainer(service: StubService())
    
    static var previews: some View {
        MainTabView()
            .environmentObject(Self.containers)
            .environmentObject(AuthenticatedViewModel(container: Self.containers))
    }
}
