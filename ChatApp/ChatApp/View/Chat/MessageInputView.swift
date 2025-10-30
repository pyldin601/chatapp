//
//  MessageInputView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageInputView: View {
    let onSend: (String) -> Void
    let onStartTyping: () -> Void
    let onStopTyping: () -> Void
    
    @State private var draft: String = ""
    @State private var isTyping: Bool = false

    var body: some View {
        HStack {
            HStack {
                TextField("Type a message", text: Binding(
                    get: { draft },
                    set: onChange
                ))
                    .textFieldStyle(.plain)
                    .frame(height: 50)
                    .padding(.horizontal, 18)
                    .glassEffect(.regular.interactive())
                
                Spacer()
                
                Button(action: onSendButtonClick) {
                    Image(systemName: "paperplane")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 50, height: 50)
                .glassEffect(.regular.interactive())
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }
    
    func onSendButtonClick() {
        onStopTyping()
        isTyping = false

        onSend(draft)
        draft = ""
    }
    
    func onChange(_ value: String) {
        if value.isEmpty && isTyping {
            isTyping = false
            onStopTyping()
        } else if !isTyping {
            isTyping = true
            onStartTyping()
        }
        draft = value
    }
}

#Preview {
    MessageInputView(
        onSend: { text in
            print("Message '\(text)' sent")
        },
        onStartTyping: {
            print("Start typing message")
        },
        onStopTyping: {
            print("Stop typing message")
        }
    )
}
