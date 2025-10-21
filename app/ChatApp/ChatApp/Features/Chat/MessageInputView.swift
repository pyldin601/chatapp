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
                    .frame(height: 40)
                    .padding(.horizontal, 18)
                    .background(.ultraThinMaterial.opacity(0.85), in: RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                            .strokeBorder(.separator, lineWidth: 1)
                    )
                
                Spacer()
                
                Button {
                    onSendButtonClick()
                } label: {
                    Image(systemName: "paperplane")
                }
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial.opacity(0.85), in: RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                        .strokeBorder(.separator, lineWidth: 1)
                )
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(16)
            .glassEffect(.regular.interactive())
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
