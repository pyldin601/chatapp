//
//  MessageInputView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageInputView: View {
    private let panelRadius: CGFloat = 18
    private let fieldRadius: CGFloat = 14
    
    let onSend: (String) -> Void
    
    @State private var draft: String = ""
    
    var body: some View {
        HStack {
            TextField("Type a message", text: $draft)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                        .strokeBorder(.separator, lineWidth: 1)
                )
            
            Spacer()
            
            Button("Send", systemImage: "paperplane", action: onSendButtonClick)
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(4)
        .glassEffect(.regular, in: .rect(cornerRadius: panelRadius))
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
