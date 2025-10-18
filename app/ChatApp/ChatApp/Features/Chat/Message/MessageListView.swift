//
//  MessageListView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageListView: View {
    let messages: [ChatMessage]
    
    var body: some View {
        ForEach(messages) { message in
            HStack {
                if message.isOwn {
                    Spacer().frame(maxWidth: 32)
                    MessageRowView(message: message)
                } else {
                    MessageRowView(message: message)
                    Spacer().frame(maxWidth: 32)
                }
            }
            
        }
    }
}

#Preview {
    MessageListView(messages: [
        makeChatMessage(nickname: "melissa", body: "Hey John 👋 How’s it going?", isOwn: false),
        makeChatMessage(nickname: "me", body: "All good! Making a chat app with SwiftUI 😎", isOwn: true)
    ])
}
