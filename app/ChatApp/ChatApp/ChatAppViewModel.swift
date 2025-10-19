//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@Observable
final class ChatAppViewModel: ObservableObject {
    var nickname: String = UserDefaults.standard.string(forKey: "nickname") ?? ""
    var messages: [ChatEvent] = []
    
    let db = Firestore.firestore()
    
    private func sendEvent(_ event: ChatEvent) async {
        do {
            let chatMetadataRef = db.collection("chat-metadata").document("chat-metadata")
            let newChatEventRef = db.collection("chat-events").document()
            
            let _ = try await db.runTransaction { (tx, _) in
                do {
                    let chatMetadataSnap = try tx.getDocument(chatMetadataRef)
                    let lastSequence = (chatMetadataSnap.data()?["lastSequence"] as? Int) ?? 0
                    let nextSequence = lastSequence + 1
                    tx.updateData(["lastSequence": nextSequence], forDocument: chatMetadataRef)
                    
                    switch event {
                    case .message(let msg):
                        tx.setData([
                            "eventType": "message",
                            "nickname": msg.nickname,
                            "text": msg.originalBody,
                            "createdAt": Timestamp(date: Date()),
                            "sequence": nextSequence
                        ], forDocument: newChatEventRef)
                    case .nicknameChanged(let evt):
                        tx.setData([
                            "eventType": "nicknameСhange",
                            "oldNickname": evt.oldNickname,
                            "newNickname": evt.newNickname,
                            "createdAt": Timestamp(date: Date()),
                            "sequence": nextSequence
                        ], forDocument: newChatEventRef)
                    }
                } catch {
                    // TODO: Handle error inside transaction
                }
                
                return
            }
        } catch {
            // TODO: Handle error after transaction
        }
    }
    
    func sendMessage(_ text: String) {
        let event: ChatEvent = .message(makeChatMessage(nickname: nickname, body: text, isOwn: true))
        
        messages.append(event)
        // TODO: Send to API
        
        Task {
            await sendEvent(event)
        }
    }
    
    func setNickname(_ newNickname: String) {
        if nickname.isEmpty || newNickname.isEmpty || newNickname == nickname {
            return
        }
        
        let event: ChatEvent = .nicknameChanged(NicknameChangedEvent(oldNickname: nickname, newNickname: newNickname))
        
        messages.append(event)
        nickname = newNickname
        
        UserDefaults.standard.set(nickname, forKey: "nickname")
        
        Task {
            await sendEvent(event)
        }
    }
    
    func loadHistory() async {
        let loadedHistory = [
            makeChatMessage(nickname: "johndoe", body: "Hello, world!", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Hey John 👋 How’s it going?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "All good! Just testing this new chat UI 😎", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Looks clean! Did you build it with SwiftUI?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "Yep, and it works surprisingly well on the first try 🎉", isOwn: true),
            makeChatMessage(nickname: "alice", body: "Does it support HTML markdown?", isOwn: false),
            makeChatMessage(nickname: "johndoe", body: "Sure, <i>this is italic</i> and <b>this is bold</b>!", isOwn: true),
        ]
        
        messages.append(contentsOf: loadedHistory.map { .message($0) })
    }
}
