//
//  ChatEvent+DTO.swift
//  ChatApp
//
//  Created by Roman on 19/10/2025.
//

extension ChatEvent {
    func toDTO() -> ChatEventDTO {
        switch self {
        case .message(let evt):
                .message(MessageEventDTO(
                    id: evt.id,
                    sequence: nil,
                    nickname: evt.nickname,
                    text: evt.originalBody,
                    createdAt: evt.createdAt,
                ))
            
        case .nicknameChange(let evt):
                .nicknameChange(NicknameChangeEventDTO(
                    id: evt.id,
                    sequence: nil,
                    oldNickname: evt.oldNickname,
                    newNickname: evt.newNickname,
                    createdAt: evt.createdAt,
                ))
        }
    }
}
