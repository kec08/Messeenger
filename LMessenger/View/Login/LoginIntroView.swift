//
//  LoginIntroView.swift
//  LMessenger
//
//  Created by 김은찬 on 6/17/25.
//

import SwiftUI

struct LoginIntroView: View {
    @State private var isShowPasswordLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Spacer()
                
                Text("환영합니다.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color.bkText)
                Text("무료 메시지와 영상통화, 음성통화를 부담없이 즐겨보세요!")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)
                
                Spacer()
                
                Button {
                    isShowPasswordLoginView.toggle()
                } label: {
                    Text("로그인")
                }.buttonStyle(LoginButtonStyle(textColor: .lineAppColor))
            }
            .navigationDestination(isPresented: $isShowPasswordLoginView) {
                LoginView()
            }
        }
    }
}

struct LoginIntroView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView()
    }
}
