//
//  LoginView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct LoginView: View {
    private let fieldRadius: CGFloat = 14
    
    @ObservedObject var vm: ChatAppViewModel
    @State var nickname: String
    
    let onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Image("LoginIcon")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .frame(width: 128, height: 128)
                .padding(.bottom, 8)
            
            
            TextField("Type a nickname", text: $nickname)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                        .strokeBorder(.separator, lineWidth: 1)
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Spacer()
            
            Button("Enter") {
                vm.setNickname(nickname)
                onLogin()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .frame(maxWidth: .infinity)
            .keyboardShortcut(.defaultAction)
            .disabled(nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    LoginView(vm: ChatAppViewModel(), nickname: "joe") {
        
    }
}
