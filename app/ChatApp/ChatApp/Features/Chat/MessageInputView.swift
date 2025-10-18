//
//  MessageInputView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageInputView: View {
    let onSend: (String) -> Void
    
    @State private var draft: String = ""
    
    var body: some View {
        HStack {
            TextField("Type a message", text: $draft)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            Button("Send", systemImage: "paperplane", action: onSendButtonClick)
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
    
    func onSendButtonClick() {
        onSend(draft)
        draft = ""
    }
}

#Preview {
    MessageInputView { text in
        print("Message '\(text)' sent")
    }
}
