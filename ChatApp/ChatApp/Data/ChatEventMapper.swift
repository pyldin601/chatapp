//
//  ChatEventMapper.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

extension ChatEventDTO {
    func toDomain() -> ChatStoreEvent {
        switch self {
        case .message(let event):
            return .message(ChatStoreEventMessage(
                id: event.id,
                nickname: event.nickname,
                text: event.text,
                deliveryStatus: .delivered,
                createdAt: event.createdAt
            ))
            
        case .nicknameChange(let event):
            return .changedNickname(ChatStoreEventChangedNickname(
                id: event.id,
                oldNickname: event.oldNickname,
                newNickname: event.newNickname,
                createdAt: event.createdAt
            ))
        }
    }

    func updateDomain(_ event: inout ChatStoreEvent) {
        event.setDelivered(self.createdAt)
        event.setSequence(self.sequence)
    }
}
