//
//  SwiftUIView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

func acronym(from nickname: String) -> String {
    guard let first = nickname.first,
          let last = nickname.last else {
        return ""
    }
    return "\(first)\(last)".uppercased()
}

struct EventView: View {
    let event: ChatEvent
    
    var body: some View {
        switch event {
        case .message(let evt):
            HStack(alignment: .top) {
                if evt.isOwn {
                    Spacer().frame(maxWidth: 68)
                    MessageView(event: evt)
                } else {
                    Text(acronym(from: evt.nickname))
                        .font(.headline)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .glassEffect(.regular.tint(Color.gray.opacity(0.2)))
                    MessageView(event: evt)
                    Spacer().frame(maxWidth: 60)
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
        EventView(event: .message(makeMessageEvent(nickname: "melissa", body: "Hey 👋", isOwn: false)))
    }
}
