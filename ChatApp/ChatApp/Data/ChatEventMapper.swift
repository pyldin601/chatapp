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
                direction: .incoming,
                deliveryStatus: .delivered,
                createdAt: event.createdAt,
                sequence: event.sequence,
            ))

        case .nicknameChange(let event):
            return .changedNickname(ChatStoreEventChangedNickname(
                id: event.id,
                oldNickname: event.oldNickname,
                newNickname: event.newNickname,
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
            return .some(.message(MessageEventDTO(
                id: event.id,
                nickname: event.nickname,
                text: event.text,
                createdAt: event.createdAt,
            )))
        case .changedNickname(let event):
            return .some(.nicknameChange(NicknameChangeEventDTO(
                id: event.id,
                oldNickname: event.oldNickname,
                newNickname: event.newNickname,
                createdAt: event.createdAt
            )))
        default:
            return .none
        }
    }
}
