//
//  MessageListView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageListView: View {
    let messages: [ChatEvent]
    
    var body: some View {
        ForEach(messages) { event in
            
            switch event {
            case .message(let msg):
                HStack {
                    if msg.isOwn {
                        Spacer().frame(maxWidth: 32)
                        MessageRowView(message: msg)
                    } else {
                        MessageRowView(message: msg)
                        Spacer().frame(maxWidth: 32)
                    }
                }
            
            case .nicknameChanged(let evt):
                HStack {
                    Spacer()
                    Text("User changed nickname from **\(evt.oldNickname)** to **\(evt.newNickname)**")
                        .font(.caption)
                    Spacer()
                }
            }
            
        }
    }
}

#Preview {
    MessageListView(messages: [
        .message(makeChatMessage(nickname: "melissa", body: "Hey John 👋 How’s it going?", isOwn: false)),
        .message(makeChatMessage(nickname: "john", body: "All good! Making a chat app with SwiftUI 😎", isOwn: true)),
        .nicknameChanged(NicknameChangedEvent(oldNickname: "john", newNickname: "j.doe")),
        .message(makeChatMessage(nickname: "j.doe", body: "I'm testing change of nickname", isOwn: true)),
    ])
}
