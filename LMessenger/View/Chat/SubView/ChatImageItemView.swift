//
//  ChatImageItemView.swift
//  LMessenger
//
//  Created by 김은찬 on 8/14/25.
//

import SwiftUI

struct ChatImageItemView: View {
    let urlString: String
    let direction: ChatItemDirection
    
    var body: some View {
        HStack(alignment: .bottom) {
            if direction == .right {
                Spacer()
            }
            
            URLImageView(urlString: urlString)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left {
                Spacer()
            }
        }
        .padding(.horizontal, 35)
        .padding(.bottom)
    }
    
}

struct ChatImageItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatImageItemView(urlString: "", direction: .left)
    }
}
