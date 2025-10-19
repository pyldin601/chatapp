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

struct MessageEvent: Codable {
    let id: String
    let sequence: Int
    let nickname: String
    let text: String
    let createdAt: Date
}

struct NicknameChangeEvent: Codable {
    let id: String
    let sequence: Int
    let oldNickname: String
    let newNickname: String
    let createdAt: Date
}

enum Event: Codable {
    case message(MessageEvent)
    case nicknameChange(NicknameChangeEvent)
    
    private enum CodingKeys: String, CodingKey {
        case eventType
    }
    
    enum EventType: String, Codable {
        case message
        case nicknameChange
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventType.self, forKey: .eventType)
        switch type {
        case .message:
            self = .message(try MessageEvent(from: decoder))
        case .nicknameChange:
            self = .nicknameChange(try NicknameChangeEvent(from: decoder))
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
        }
    }
}

@Observable
final class ChatAppViewModel: ObservableObject {
    var nickname: String = UserDefaults.standard.string(forKey: "nickname") ?? ""
    var messages: [ChatEvent] = []
    
    private let chatEventRepository: ChatEventRepository = FirebaseChatEventRepositoryImpl()
    
    private let db = Firestore.firestore()
    private var events: CollectionReference { db.collection("chat-events") }
    private var meta: CollectionReference { db.collection("chat-metadata") }
    
    private var streamTask: Task<Void, Never>?
    
    private func sendEvent(_ event: ChatEvent) async {
        do {
            
            let eventDto: ChatEventDTO = switch event {
            case .message(let msg):
                    .message(MessageEventDTO(
                        id: msg.id.uuidString,
                        sequence: nil,
                        nickname: msg.nickname,
                        text: msg.originalBody,
                        createdAt: Date(),
                    ))
                
            case .nicknameChanged(let evt):
                    .nicknameChange(NicknameChangeEventDTO(
                        id: evt.id.uuidString,
                        sequence: nil,
                        oldNickname: evt.oldNickname,
                        newNickname: evt.newNickname,
                        createdAt: Date(),
                    ))
            }
            
            try await self.chatEventRepository.publish(eventDto)
            
        } catch {
            print("Error:", error.localizedDescription)
            // TODO: Handle error after transaction
        }
    }
    
    func sendMessage(_ text: String) {
        let event: ChatEvent = .message(makeChatMessage(nickname: nickname, body: text, isOwn: true))
        
        // messages.append(event)
        
        Task {
            await sendEvent(event)
        }
    }
    
    func setNickname(_ newNickname: String) {
        if nickname.isEmpty || newNickname.isEmpty || newNickname == nickname {
            return
        }
        
        let event: ChatEvent = .nicknameChanged(NicknameChangedEvent(oldNickname: nickname, newNickname: newNickname))
        
        // messages.append(event)
        nickname = newNickname
        
        UserDefaults.standard.set(nickname, forKey: "nickname")
        
        Task {
            await sendEvent(event)
        }
    }
    
    func subscribe() async {
        streamTask?.cancel()
        streamTask = Task {
            
            let query = events
                .order(by: "sequence", descending: false)
                .limit(to: 100)
            
            let listener = query.addSnapshotListener { snap, err in
                if let err {
                    // You may surface an error via another callback if needed
                    print("Listener error:", err.localizedDescription)
                    return
                }
                guard let snap else { return }
                
                for change in snap.documentChanges {
                    guard change.type == .added else { continue }
                    
                    do {
                        let doc = try change.document.data(as: Event.self)
                        
                        switch doc {
                        case .message(let evt):
                            let chatEvent: ChatEvent = .message(makeChatMessage(nickname: evt.nickname, body: evt.text, isOwn: evt.nickname == self.nickname))
                            self.messages.append(chatEvent)
                        case .nicknameChange(let evt):
                            let chatEvent: ChatEvent = .nicknameChanged(NicknameChangedEvent(oldNickname: evt.oldNickname, newNickname: evt.newNickname))
                            self.messages.append(chatEvent)
                        }
                        
                        print("New document: \(doc)")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            
            do {
                try await Task.sleep(nanoseconds: .max)
            } catch {
                // Task canceled -> remove listener
                listener.remove()
            }
        }
    }
    
    func unsubscribe() async {
        streamTask?.cancel()
    }
}
