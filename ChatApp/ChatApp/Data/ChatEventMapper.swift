//
//  ChatEventMapper.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

extension ChatEventDTO {
    func toDomain(_ ownNickname: String) -> ChatStoreEvent {
        switch self {
        case .message(let event):
                .message(ChatStoreEventMessage(
                    id: event.id,
                    nickname: event.nickname,
                    text: event.text,
                    direction: event.nickname == ownNickname ? .outgoing : .incoming,
                    deliveryStatus: .delivered,
                    createdAt: event.createdAt,
                    sequence: event.sequence,
                ))
        case .nicknameChange(let event):
                .changedNickname(ChatStoreEventChangedNickname(
                    id: event.id,
                    oldNickname: event.oldNickname,
                    newNickname: event.newNickname,
                    createdAt: event.createdAt,
                    sequence: event.sequence,
                ))
        case .startTyping(let event):
                .startTypingMessage(ChatStoreEventStartTyping(
                    id: event.id,
                    nickname: event.nickname,
                    createdAt: event.createdAt,
                    sequence: event.sequence,
                ))
        }
    }
    
    func updateDomain(_ event: inout ChatStoreEvent) {
        event.setDelivered(self.createdAt)
        event.setSequence(self.sequence)
    }
}

extension ChatStoreEvent {
    func toDTO() -> Optional<ChatEventDTO> {
        switch self {
        case .message(let event):
                .some(.message(MessageEventDTO(
                    id: event.id,
                    nickname: event.nickname,
                    text: event.text,
                    createdAt: event.createdAt,
                )))
        case .changedNickname(let event):
                .some(.nicknameChange(NicknameChangeEventDTO(
                    id: event.id,
                    oldNickname: event.oldNickname,
                    newNickname: event.newNickname,
                    createdAt: event.createdAt
                )))
        case .startTypingMessage(let event):
                .some(.startTyping(StartTypingEventDTO(
                    id: event.id,
                    nickname: event.nickname,
                    createdAt: event.createdAt
                )))
        }
    }
}
