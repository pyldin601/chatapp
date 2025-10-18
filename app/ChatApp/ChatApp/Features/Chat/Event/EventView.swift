//
//  SwiftUIView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct EventView: View {
    let event: ChatEvent
    
    var body: some View {
        switch event {
        case .message(let msg):
            HStack {
                if msg.isOwn {
                    Spacer().frame(maxWidth: 32)
                    MessageView(message: msg)
                } else {
                    MessageView(message: msg)
                    Spacer().frame(maxWidth: 32)
                }
            }
            
        case .nicknameChanged(let evt):
            HStack {
                Spacer()
                Text("User **\(evt.oldNickname)** changed nickname to **\(evt.newNickname)**")
                    .font(.caption)
                Spacer()
            }
        }
    }
}

#Preview {
    VStack {
        EventView(event: .message(makeChatMessage(nickname: "foo", body: "Hello 👋", isOwn: true)))
        EventView(event: .nicknameChanged(NicknameChangedEvent(oldNickname: "foo", newNickname: "bar")))
        EventView(event: .message(makeChatMessage(nickname: "bar", body: "Hey 👋", isOwn: true)))
    }
}
