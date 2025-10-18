//
//  MessageListView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct EventListView: View {
    let messages: [ChatEvent]
    
    var body: some View {
        ForEach(messages) { event in
            EventView(event: event)
        }
    }
}

#Preview {
    EventListView(messages: [
        .message(makeChatMessage(nickname: "melissa", body: "Hey John 👋 How’s it going?", isOwn: false)),
        .message(makeChatMessage(nickname: "john", body: "All good! Making a chat app with SwiftUI 😎", isOwn: true)),
        .nicknameChanged(NicknameChangedEvent(oldNickname: "john", newNickname: "j.doe")),
        .message(makeChatMessage(nickname: "j.doe", body: "I'm testing change of nickname", isOwn: true)),
    ])
}
