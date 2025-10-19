//
//  ChatMessageView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageView: View {
    let event: MessageEvent
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.nickname).font(.caption)
                Text(event.body)
            }
            .padding(8)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.secondary.opacity(0.12))
        )
    }
}

#Preview {
    VStack {
        MessageView(event: makeMessageEvent(nickname: "melissa", body: "Hey John 👋 How’s it going?", isOwn: false))
        MessageView(event: makeMessageEvent(nickname: "me", body: "All good! Making a chat app with SwiftUI 😎", isOwn: true))
    }
}
