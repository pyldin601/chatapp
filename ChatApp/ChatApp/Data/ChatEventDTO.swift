//
//  ChatEventDTO.swift
//  ChatApp
//
//  Created by Roman on 19/10/2025.
//

import SwiftUI

struct MessageEventDTO: Codable {
    let id: String
    var sequence: Int?
    let nickname: String
    let text: String
    let createdAt: Date
}

struct NicknameChangeEventDTO: Codable {
    let id: String
    var sequence: Int?
    let oldNickname: String
    let newNickname: String
    let createdAt: Date
}

struct StartTypingEventDTO: Codable {
    let id: String
    var sequence: Int?
    let nickname: String
    let createdAt: Date
}

struct StopTypingEventDTO: Codable {
    let id: String
    var sequence: Int?
    let nickname: String
    let createdAt: Date
}

enum ChatEventDTO: Codable, Identifiable {
    case message(MessageEventDTO)
    case nicknameChange(NicknameChangeEventDTO)
    case startTyping(StartTypingEventDTO)
    case stopTyping(StopTypingEventDTO)
    
    var id: String {
        switch self {
        case .message(let e):
            return e.id
        case .nicknameChange(let e):
            return e.id
        case .startTyping(let e):
            return e.id
        case .stopTyping(let e):
            return e.id
        }
    }
    
    var createdAt: Date {
        switch self {
        case .message(let e):
            return e.createdAt
        case .nicknameChange(let e):
            return e.createdAt
        case .startTyping(let e):
            return e.createdAt
        case .stopTyping(let e):
            return e.createdAt
        }
    }
    
    var sequence: Int? {
        switch self {
        case .message(let e):
            return e.sequence
        case .nicknameChange(let e):
            return e.sequence
        case .startTyping(let e):
            return e.sequence
        case .stopTyping(let e):
            return e.sequence
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventType
    }
    
    enum EventType: String, Codable {
        case message
        case nicknameChange
        case startTyping
        case stopTyping
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventType.self, forKey: .eventType)
        switch type {
        case .message:
            self = .message(try MessageEventDTO(from: decoder))
        case .nicknameChange:
            self = .nicknameChange(try NicknameChangeEventDTO(from: decoder))
        case .startTyping:
            self = .startTyping(try StartTypingEventDTO(from: decoder))
        case .stopTyping:
            self = .stopTyping(try StopTypingEventDTO(from: decoder))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .message(let event):
            try event.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(EventType.message, forKey: .eventType)
        case .nicknameChange(let event):
            try event.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(EventType.nicknameChange, forKey: .eventType)
        case .startTyping(let event):
            try event.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(EventType.startTyping, forKey: .eventType)
        case .stopTyping(let event):
            try event.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(EventType.stopTyping, forKey: .eventType)
        }
    }
    
    func setSequence(_ sequence: Int) -> Self {
        switch self {
        case .message(var event):
            event.sequence = sequence
            return .message(event)
        case .nicknameChange(var event):
            event.sequence = sequence
            return .nicknameChange(event)
        case .startTyping(var event):
            event.sequence = sequence
            return .startTyping(event)
        case .stopTyping(var event):
            event.sequence = sequence
            return .stopTyping(event)
        }
    }
}
