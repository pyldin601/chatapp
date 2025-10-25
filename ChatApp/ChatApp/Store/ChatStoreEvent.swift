//
//  ChatStoreEvent.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI

struct ChatStoreEventMessage {
    enum DeliveryStatus { case pending, sent, delivered, unsent }
    enum Direction { case incoming, outgoing }
    
    let id: String
    let nickname: String
    let text: String
    
    var deliveryStatus: DeliveryStatus
    var createdAt: Date
    var sequence: Int?
}

struct ChatStoreEventTypingMessage {
    let id: String
    let nickname: String
    
    var createdAt: Date
    var sequence: Int?
}

struct ChatStoreEventChangedNickname {
    let id: String
    let oldNickname: String
    let newNickname: String
    
    var createdAt: Date
    var sequence: Int?
}

enum ChatStoreEvent: Identifiable {
    case message(ChatStoreEventMessage)
    case typingMessage(ChatStoreEventTypingMessage)
    case changedNickname(ChatStoreEventChangedNickname)
    
    var id: String {
        switch self {
        case .message(let event): return event.id
        case .typingMessage(let event): return event.id
        case .changedNickname(let event): return event.id
        }
    }
    
    var createdAt: Date {
        switch self {
        case .message(let event): return event.createdAt
        case .typingMessage(let event): return event.createdAt
        case .changedNickname(let event): return event.createdAt
        }
    }
    
    var sequence: Int? {
        switch self {
        case .message(let event): return event.sequence
        case .typingMessage(let event): return event.sequence
        case .changedNickname(let event): return event.sequence
        }
    }
    
    mutating func setSequence(_ newSequence: Int?) {
        switch self {
        case .message(var event):
            event.sequence = newSequence
            self = .message(event)
        case .typingMessage(var event):
            event.sequence = newSequence
            self = .typingMessage(event)
        case .changedNickname(var event):
            event.sequence = newSequence
            self = .changedNickname(event)
        }
    }
    
    mutating func setSent(_ newCreatedAt: Date) {
        guard case .message(var msg) = self else { return }
        
        msg.createdAt = newCreatedAt
        msg.deliveryStatus = .sent
        self = .message(msg)
    }

    mutating func setDelivered(_ newCreatedAt: Date) {
        guard case .message(var msg) = self else { return }
        
        msg.createdAt = newCreatedAt
        msg.deliveryStatus = .delivered
        self = .message(msg)
    }

    mutating func setUnsent() {
        guard case .message(var msg) = self else { return }
        
        msg.deliveryStatus = .unsent
        self = .message(msg)
    }
}
