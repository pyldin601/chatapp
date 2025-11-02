//
//  ChatEventDTO.swift
//  ChatApp
//
//  Created by Roman on 19/10/2025.
//

import SwiftUI

enum ChatEventDTO: Codable, Identifiable {
    
    struct Message: Codable {
        let id: String
        var sequence: Int?
        let nickname: String
        let text: String
        let createdAt: Date
    }

    struct NicknameChange: Codable {
        let id: String
        var sequence: Int?
        let oldNickname: String
        let newNickname: String
        let createdAt: Date
    }

    struct Typing: Codable {
        let id: String
        var sequence: Int?
        let nickname: String
        let createdAt: Date
    }

    case message(Message)
    case nicknameChange(NicknameChange)
    case typing(Typing)
    
    var id: String {
        switch self {
        case .message(let e):
            return e.id
        case .nicknameChange(let e):
            return e.id
        case .typing(let e):
            return e.id
        }
    }
    
    var createdAt: Date {
        switch self {
        case .message(let e):
            return e.createdAt
        case .nicknameChange(let e):
            return e.createdAt
        case .typing(let e):
            return e.createdAt
        }
    }
    
    var sequence: Int? {
        switch self {
        case .message(let e):
            return e.sequence
        case .nicknameChange(let e):
            return e.sequence
        case .typing(let e):
            return e.sequence
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventType
    }
    
    enum EventType: String, Codable {
        case message
        case nicknameChange
        case typing
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventType.self, forKey: .eventType)
        switch type {
        case .message:
            self = .message(try Message(from: decoder))
        case .nicknameChange:
            self = .nicknameChange(try NicknameChange(from: decoder))
        case .typing:
            self = .typing(try Typing(from: decoder))
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
        case .typing(let event):
            try event.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(EventType.typing, forKey: .eventType)
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
        case .typing(var event):
            event.sequence = sequence
            return .typing(event)
        }
    }
}
