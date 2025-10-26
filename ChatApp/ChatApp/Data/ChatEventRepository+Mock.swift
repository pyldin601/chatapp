//
//  ChatEventRepositoryMock.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI


final class ChatEventRepositoryMock: ChatEventRepository {
    func publish(_ event: ChatEventDTO) async throws {
        //
    }
    
    func subscribe() -> AsyncStream<ChatEventDTO> {
        AsyncStream { continuation in
            
        }
    }
}
