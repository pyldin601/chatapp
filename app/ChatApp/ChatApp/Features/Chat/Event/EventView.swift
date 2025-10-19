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
        case .message(let evt):
            HStack {
                if evt.isOwn {
                    Spacer().frame(maxWidth: 32)
                    MessageView(event: evt)
                } else {
                    MessageView(event: evt)
                    Spacer().frame(maxWidth: 32)
                }
            }
            
        case .nicknameChange(let evt):
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
        EventView(event: .message(makeMessageEvent(nickname: "foo", body: "Hello 👋", isOwn: true)))
        EventView(event: .nicknameChange(NicknameChangeEvent(oldNickname: "foo", newNickname: "bar")))
        EventView(event: .message(makeMessageEvent(nickname: "bar", body: "Hey 👋", isOwn: true)))
    }
}
