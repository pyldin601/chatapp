//
//  ChatStoreEvent.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI

enum ChatStoreEvent: Identifiable {
    struct Message {
        enum DeliveryStatus { case pending, sent, delivered, unsent }
        enum Direction { case incoming, outgoing }
        
        let id: String
        let nickname: String
        let text: String
        let direction: Direction
        
        var deliveryStatus: DeliveryStatus
        var createdAt: Date
        var sequence: Int?
    }
    
    struct NicknameChange {
        let id: String
        let oldNickname: String
        let newNickname: String
        
        var createdAt: Date
        var sequence: Int?
    }

    struct Typing {
        let id: String
        let nickname: String
        
        var createdAt: Date
        var sequence: Int?
    }

    case message(Message)
    case changedNickname(NicknameChange)
    case startTypingMessage(Typing)
    
    var id: String {
        switch self {
        case .message(let event): return event.id
        case .startTypingMessage(let event): return event.id
        case .changedNickname(let event): return event.id
        }
    }
    
    var createdAt: Date {
        switch self {
        case .message(let event): return event.createdAt
        case .startTypingMessage(let event): return event.createdAt
        case .changedNickname(let event): return event.createdAt
        }
    }
    
    var sequence: Int? {
        switch self {
        case .message(let event): return event.sequence
        case .startTypingMessage(let event): return event.sequence
        case .changedNickname(let event): return event.sequence
        }
    }
    
    mutating func setSequence(_ newSequence: Int?) {
        switch self {
        case .message(var event):
            event.sequence = newSequence
            self = .message(event)
        case .startTypingMessage(var event):
            event.sequence = newSequence
            self = .startTypingMessage(event)
        case .changedNickname(var event):
            event.sequence = newSequence
            self = .changedNickname(event)
        }
    }
    
    mutating func setSent() {
        guard case .message(var msg) = self else { return }
        
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
