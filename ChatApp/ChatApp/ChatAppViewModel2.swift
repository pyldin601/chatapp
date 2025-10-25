//
//  ChatAppViewModel2.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import Foundation

final class ChatAppViewModel2 {
    let chatEventRepository: ChatEventRepository
    let chatStore: ChatStore
    let nicknameStore: NicknameStore
    
    var chatEventsSubscriberTask: Task<Void, Never>?
    
    init(
        chatEventRepository: ChatEventRepository,
        chatStore: ChatStore,
        nicknameStore: NicknameStore
    ) {
        self.chatEventRepository = chatEventRepository
        self.chatStore = chatStore
        self.nicknameStore = nicknameStore
    }
    
    func connect() {
        self.chatEventsSubscriberTask?.cancel()

        self.chatEventsSubscriberTask = Task {
            for await event in self.chatEventRepository.subscribe() {
                self.chatStore.reconcileChatEventDTO(eventDto: event)
            }

            // Disconnected because of network error?
            // Reconnect?
        }
    }
    
    func disconnect() {
        self.chatEventsSubscriberTask?.cancel()
    }
    
    func sendMessage(_ text: String) {
        let event = ChatStoreEventMessage(
            id: UUID().uuidString,
            nickname: self.nicknameStore.nickname,
            text: text,
            deliveryStatus: .pending,
            createdAt: Date()
        )
        
        Task {
            await self.sendEvent(.message(event))
        }
    }
    
    func changeNickname(_ nickname: String) {
        let oldNickname = self.nicknameStore.nickname
        let newNickname = nickname
        
        let event = ChatStoreEventChangedNickname(
            id: UUID().uuidString,
            oldNickname: oldNickname,
            newNickname: newNickname,
            createdAt: Date()
        )
        
        Task {
            await self.sendEvent(.changedNickname(event))
        }
    }
    
    func sendTyping() {
        let event = ChatStoreEventTypingMessage(
            id: UUID().uuidString,
            nickname: self.nicknameStore.nickname,
            createdAt: Date()
        )
        
        Task {
            await self.sendEvent(.typingMessage(event))
        }
    }
    
    private func sendEvent(_ event: ChatStoreEvent) async {
        self.chatStore.addChatEvent(event: event)
        
        if let eventDTO = event.toDTO() {
            do {
                try await self.chatEventRepository.publish(eventDTO)
                self.chatStore.updateChatEvent(id: event.id) {
                    $0.setSent()
                }
            } catch {
                self.chatStore.updateChatEvent(id: event.id) {
                    $0.setUnsent()
                }
                
                // TODO: Notify about msg sending error
                print("Unable to send event: ", error.localizedDescription)
            }
        }
        
    }
}
