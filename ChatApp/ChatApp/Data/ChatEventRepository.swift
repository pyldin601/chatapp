//
//  ChatEventRepository.swift
//  ChatApp
//
//  Created by Roman on 19/10/2025.
//

protocol ChatEventRepository {
    func publish(_ event: ChatEventDTO) async throws
    func subscribe() -> AsyncStream<ChatEventDTO>
}
