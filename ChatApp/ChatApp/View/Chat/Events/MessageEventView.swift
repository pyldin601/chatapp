//
//  Events:MessageView.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI


func acronym(from nickname: String) -> String {
    guard let first = nickname.first,
          let last = nickname.last else {
        return ""
    }
    return "\(first)\(last)".uppercased()
}

struct IncomingMessageEventView: View {
    let event: ChatStoreEvent.Message
    
    var body: some View {
        HStack(alignment: .top) {
            Text(acronym(from: event.nickname))
                .font(.headline)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .glassEffect(.regular.tint(Color.gray.opacity(0.2)))
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.nickname).font(.caption).opacity(0.65)
                    Text(event.text)
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
            Spacer()
        }
    }
}

struct OutgoingMessageStatusView: View {
    let status: ChatStoreEvent.Message.DeliveryStatus
    
    var body: some View {
        Group {
            switch status {
            case .pending:
                Image(systemName: "clock")
            case .sent:
                Image(systemName: "checkmark")
            case .unsent:
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
            case .delivered:
                ZStack {
                    Image(systemName: "checkmark")
                        .offset(x: -2, y: 0)
                    Image(systemName: "checkmark")
                        .offset(x: 2, y: 0)
                }
                .drawingGroup()
            }
        }
        .frame(width: 10)
        .font(.caption2.weight(.semibold))
    }
}

struct OutgoingMessageEventView: View {
    let event: ChatStoreEvent.Message
    
    var body: some View {
        HStack {
            Spacer()
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.text)
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                OutgoingMessageStatusView(status: event.deliveryStatus)
                    .padding(.trailing, 8)
                    .padding(.bottom, 6)
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
}


struct MessageEventView: View {
    let event: ChatStoreEvent.Message
    
    var body: some View {
        if event.direction == .incoming {
            IncomingMessageEventView(event: event)
        } else {
            OutgoingMessageEventView(event: event)
        }
    }
}

#Preview {
    VStack {
        // Incoming
        MessageEventView(event: ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world!\nHello, world!",
            direction: .incoming,
            deliveryStatus: .delivered,
            createdAt: Date()
        ))
        // Outgoing
        MessageEventView(event: ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world! - Pending",
            direction: .outgoing,
            deliveryStatus: .pending,
            createdAt: Date()
        ))
        MessageEventView(event: ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world! - Sent",
            direction: .outgoing,
            deliveryStatus: .sent,
            createdAt: Date()
        ))
        MessageEventView(event: ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world! - Delivered",
            direction: .outgoing,
            deliveryStatus: .delivered,
            createdAt: Date()
        ))
        MessageEventView(event: ChatStoreEvent.Message(
            id: UUID().uuidString,
            nickname: "john",
            text: "Hello, world! - Unsent",
            direction: .outgoing,
            deliveryStatus: .unsent,
            createdAt: Date()
        ))
    }
}
