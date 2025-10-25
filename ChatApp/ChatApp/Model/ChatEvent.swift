//
//  ChatEvent.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct MessageEvent: Identifiable {
    let id = UUID().uuidString
    let nickname: String;
    let body: AttributedString;
    let originalBody: String;
    let isOwn: Bool
    let createdAt = Date()
}

struct NicknameChangeEvent: Identifiable {
    let id = UUID().uuidString
    let oldNickname: String
    let newNickname: String
    let createdAt = Date()
}

enum ChatEvent: Identifiable {
    case message(MessageEvent)
    case nicknameChange(NicknameChangeEvent)
    
    var id: String {
        switch self {
        case .message(let msg):
            return msg.id
        
        case .nicknameChange(let evt):
            return evt.id
        }
    }

    var createdAt: Date {
        switch self {
        case .message(let msg):
            return msg.createdAt
        
        case .nicknameChange(let evt):
            return evt.createdAt
        }
    }
}
