//
//  ChatAppViewModel+Mock.swift
//  ChatApp
//
//  Created by Roman on 26/10/2025.
//

import SwiftUI


func createPreviewEvents(chatStore: ChatStore) {
    chatStore.addChatEvent(event: .message(.init(
        id: "1",
        nickname: "Alice",
        text: "Hey there 👋",
        direction: .incoming,
        deliveryStatus: .delivered,
        createdAt: Date().addingTimeInterval(-300),
        sequence: 1
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "2",
        nickname: "Roman",
        text: "Hi Alice! How are you?",
        direction: .outgoing,
        deliveryStatus: .sent,
        createdAt: Date().addingTimeInterval(-280),
        sequence: 2
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "3",
        nickname: "Alice",
        text: "All good, just trying out this new chat app 😄",
        direction: .incoming,
        deliveryStatus: .delivered,
        createdAt: Date().addingTimeInterval(-250),
        sequence: 3
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "4",
        nickname: "Roman",
        text: "Haha nice! Looks like it works pretty well.",
        direction: .outgoing,
        deliveryStatus: .sent,
        createdAt: Date().addingTimeInterval(-220),
        sequence: 4
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "5",
        nickname: "Alice",
        text: "By the way, I might change my nickname to *Alicia* soon.",
        direction: .incoming,
        deliveryStatus: .delivered,
        createdAt: Date().addingTimeInterval(-180),
        sequence: 5
    )))

    // nickname change event
    chatStore.addChatEvent(event: .changedNickname(.init(
        id: "6",
        oldNickname: "Alice",
        newNickname: "Alicia",
        createdAt: Date().addingTimeInterval(-170),
        sequence: 6
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "7",
        nickname: "Alicia",
        text: "Okay, done! New nickname 😎",
        direction: .incoming,
        deliveryStatus: .delivered,
        createdAt: Date().addingTimeInterval(-160),
        sequence: 7
    )))

    chatStore.addChatEvent(event: .message(.init(
        id: "8",
        nickname: "Roman",
        text: "Looks great, Alicia 👍",
        direction: .outgoing,
        deliveryStatus: .sent,
        createdAt: Date().addingTimeInterval(-140),
        sequence: 8
    )))
}

func createPreviewVM() -> ChatAppViewModel {
    let chatEventRepository = ChatEventRepositoryMock()
    let chatStore = ChatStore()
    let nicknameStore = NicknameStore()
    let typingIndicatorStore = TypingIndicatorStore()
    
    typingIndicatorStore.markTyping(nickname: "Roman", eventTime: Date())
    
    createPreviewEvents(chatStore: chatStore)
    
    return ChatAppViewModel(
        chatEventRepository: chatEventRepository,
        chatStore: chatStore,
        nicknameStore: nicknameStore,
        typingIndicatorStore: typingIndicatorStore
    )
}

