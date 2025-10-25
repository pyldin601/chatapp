//
//  MessageInputView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageInputView: View {
    private let fieldRadius: CGFloat = 20
    
    let onSend: (String) -> Void
    
    @State private var draft: String = ""
    
    var body: some View {
        HStack {
            HStack {
                TextField("Type a message", text: $draft)
                    .textFieldStyle(.plain)
                    .frame(height: 50)
                    .padding(.horizontal, 18)
                    .glassEffect(.regular.interactive())
                
                Spacer()
                
                Button {
                    onSendButtonClick()
                } label: {
                    Image(systemName: "paperplane")
                }
                .frame(width: 50, height: 50)
                .glassEffect(.regular.interactive())
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
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
