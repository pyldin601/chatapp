//
//  ChatMessageView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct OwnMessageView: View {
    let event: MessageEvent
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .glassEffect(
            .regular.tint(
                Color(red: 48/255, green: 85/255, blue: 133/255).opacity(0.75),
            ),
            in: .rect(cornerRadius: 16.0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct MessageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let event: MessageEvent
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.nickname).font(.caption).opacity(0.65)
                Text(event.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .glassEffect(
            .regular.tint(
                Color.gray.opacity(0.15),
            ),
            in: .rect(cornerRadius: 16.0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    VStack {
        MessageView(event: makeMessageEvent(nickname: "melissa", body: "Hey John 👋 How’s it going?", isOwn: false))
        OwnMessageView(event: makeMessageEvent(nickname: "me", body: "All good! Making a chat app with SwiftUI 😎", isOwn: true))
        OwnMessageView(event: makeMessageEvent(nickname: "me", body: "You?", isOwn: true))
    }
}
