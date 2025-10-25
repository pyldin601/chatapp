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
    
    private let chatEventRepository: ChatEventRepository = FirebaseChatEventRepositoryImpl()

    private var streamTask: Task<Void, Never>?
    
    private func sendEvent(_ event: ChatEvent) async {
        do {
            let eventDto: ChatEventDTO = event.toDTO()
            try await self.chatEventRepository.publish(eventDto)
        } catch {
            print("Error:", error.localizedDescription)
            // TODO: Handle error after transaction
        }
    }
    
    func sendMessage(_ text: String) {
        let event: ChatEvent = .message(makeMessageEvent(nickname: nickname, body: text, isOwn: true))
        
        // TODO: Optimistic update
        // messages.append(event)
        
        Task {
            await sendEvent(event)
        }
    }
    
    func setNickname(_ newNickname: String) {
        if nickname.isEmpty || newNickname.isEmpty || newNickname == nickname {
            return
        }
        
        let event: ChatEvent = .nicknameChange(NicknameChangeEvent(oldNickname: nickname, newNickname: newNickname))
        
        // TODO: Optimistic update
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
            for await evt in self.chatEventRepository.subscribe() {
                switch evt {
                case .message(let evt):
                    let chatEvent: ChatEvent = .message(makeMessageEvent(nickname: evt.nickname, body: evt.text, isOwn: evt.nickname == self.nickname))
                    self.messages.append(chatEvent)

                case .nicknameChange(let evt):
                    let chatEvent: ChatEvent = .nicknameChange(NicknameChangeEvent(oldNickname: evt.oldNickname, newNickname: evt.newNickname))
                    self.messages.append(chatEvent)
                }
            }
        }
    }

    func unsubscribe() async {
        streamTask?.cancel()
    }
}
