//
//  LoginView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: ChatAppViewModel
    @State var nickname: String
    
    let onLogin: () -> Void

    var body: some View {
        VStack {
            TextField("Type a nickname", text: $nickname)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button("Enter") {
                vm.setNickname(nickname)
                onLogin()
            }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                .disabled(nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

#Preview {
    LoginView(vm: ChatAppViewModel(), nickname: "joe") {
        
    }
}
