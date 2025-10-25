//
//  ChatStore.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import SwiftUI
import Combine
import OrderedCollections

@MainActor
final class ChatStore: ObservableObject {
    
    @Published private(set) var events: OrderedDictionary<String, ChatStoreEvent> = [:]
    
    func reconcileEventDTO(eventDto: ChatEventDTO) {
        if var existingEvent = events[eventDto.id] {
            // Update existing event from event DTO
            eventDto.updateDomain(&existingEvent)
        } else {
            // Create new event from event DTO
            let event = eventDto.toDomain()
            
            events[event.id] = event
        }

        resort()
    }
    
    private func resort() {
        events.sort { lhs, rhs in
            switch (lhs.value.sequence, rhs.value.sequence) {
            case let (x?, y?): return x < y
            case (nil, nil):   return lhs.value.createdAt < rhs.value.createdAt
            case (nil, _):     return false
            case (_, nil):     return true
            }
        }
    }
}
