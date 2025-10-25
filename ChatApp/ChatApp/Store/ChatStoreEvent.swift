//
//  ChatStoreEvent.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI

struct ChatStoreEventIncomingMessage {
    let id: String
    let nickname: String
    let text: String
    let timestamp: Date
}

struct ChatStoreEventOutgoingMessage {
    let id: String
    let text: String
    let timestamp: String
}

struct ChatStoreEventTypingMessage {
    let id: String
    let nickname: String
}

struct ChatStoreEventChangedNickname {
    let id: String
    let oldNickname: String
    let newNickname: String
}

enum ChatStoreEvent: Identifiable {
    case incomingMessage(ChatStoreEventIncomingMessage)
    case outgoingMessage(ChatStoreEventOutgoingMessage)
    case typingMessage(ChatStoreEventTypingMessage)
    case changedNickname(ChatStoreEventChangedNickname)
    
    var id: String {
        switch self {
        case .incomingMessage(let event): return event.id
        case .outgoingMessage(let event): return event.id
        case .typingMessage(let event): return event.id
        case .changedNickname(let event): return event.id
        }
    }
}
