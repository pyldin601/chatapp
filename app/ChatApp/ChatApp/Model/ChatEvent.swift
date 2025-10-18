//
//  ChatEvent.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct NicknameChangedEvent: Identifiable {
    let id = UUID()
    let oldNickname: String
    let newNickname: String
}

enum ChatEvent: Identifiable {
    case message(ChatMessage)
    case nicknameChanged(NicknameChangedEvent)
    
    var id: String {
        switch self {
        case .message(let msg):
            return "message-\(msg.id)"
        case .nicknameChanged(let evt):
            return "nickname-changed-\(evt.id)"
        }
    }
}
