//
//  ChatEventsView.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI

struct ChatEventsView<Events: RandomAccessCollection>: View
where Events.Element == ChatStoreEvent {
    let events: Events
    
    var body: some View {
        ForEach(events) { event in
            switch event {
            case .message(let evt):
                MessageEventView(event: evt)
            case .changedNickname(let evt):
                NicknameChangeEventView(event: evt)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ChatEventsView(events: [
        .message(ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world!\nHello, world!",
            direction: .incoming,
            deliveryStatus: .delivered,
            createdAt: Date()
        )),
        .changedNickname(ChatStoreEvent.NicknameChange(
            id: UUID().uuidString,
            oldNickname: "foo",
            newNickname: "bar",
            createdAt: Date()
        )),
        .message(ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "bar",
            text: "Hello, world! - Pending",
            direction: .outgoing,
            deliveryStatus: .pending,
            createdAt: Date()
        ))
    ])
}
