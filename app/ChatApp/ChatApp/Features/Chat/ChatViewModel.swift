//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import Combine
import SwiftUI

@Observable
final class ChatViewModel: ObservableObject {
    var nickname: String
    var messages: [ChatMessage] = []
    
    init(nickname: String) {
        _nickname = nickname
    }
    
    func sendMessage(_ text: String) {
        messages.append(makeChatMessage(nickname: nickname, body: text, isOwn: true))
        // TODO: Send to API
    }
    
    func changeNickname(_ newNickname: String) {
        nickname = newNickname
    }
    
    func loadHistory() async {
        print("loading history...")
        
        let loadedHistory = [
            makeChatMessage(nickname: "johndoe", body: "Hello, world!", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Hey John 👋 How’s it going?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "All good! Just testing this new chat UI 😎", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Looks clean! Did you build it with SwiftUI?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "Yep, and it works surprisingly well on the first try 🎉", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Does it support HTML markdown?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "Sure, <i>this is italic</i> and <b>this is bold</b>!", isOwn: true),
        ]
        
        messages.append(contentsOf: loadedHistory)
    }
}
