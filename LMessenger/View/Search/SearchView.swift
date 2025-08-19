//
//  SearchView.swift
//  LMessenger
//
//  Created by 김은찬 on 8/8/25.
//

import SwiftUI

public struct SearchView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: SearchViewModel
    
    public var body: some View {
        VStack {
            topView
            
            List {
                ForEach(viewModel.searchResults) { result in
                    HStack(spacing: 8) {
                        URLImageView(urlString: result.profileURL)
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                        Text(result.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.bkText)
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 30)
                }
            }
            .listStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button {
                navigationRouter.pop()
            } label : {
                Image("back_search")
            }
            
            SearchBar(text: $viewModel.searchText,
                      shouldBecomeFirstResponder: $viewModel.shouldBecomeFirstResponder)
            
            Button {
                
            } label : {
                Image("close_search")
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(container: DIContainer(service: StubService()), userId: "user1_id"))
    }
}
