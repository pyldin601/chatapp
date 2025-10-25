//
//  ChatStore.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI
import Combine

@MainActor
final class ChatStore: ObservableObject {
    @Published private(set) var events: [ChatStoreEvent] = []
    
    func handleEventDTO(eventDto: ChatEventDTO) {

        if var existingEvent = events.first(where: { $0.id == eventDto.id }) {
            // Update existing event from event DTO
            eventDto.updateDomain(&existingEvent)
        } else {
            // Create new event from event DTO
            let event = eventDto.toDomain()

            events.append(event)
        }

        resort()
    }
    
    private func resort() {
        events.sort { lhs, rhs in
            switch (lhs.sequence, rhs.sequence) {
            case let (x?, y?): return x < y
            case (nil, nil):   return lhs.createdAt < rhs.createdAt
            case (nil, _):     return false
            case (_, nil):     return true
            }
        }
    }
}
