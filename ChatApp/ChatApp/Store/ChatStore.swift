//
//  ChatStore.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI
import Combine

final class ChatStore: ObservableObject {
    var events: [ChatStoreEvent] = []
    
    func addIncomingChatEvent(event: ChatEventDTO) {}
}
