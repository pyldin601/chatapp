//
//  ChatStore.swift
//  ChatApp
//
//  Created by Roman on 23/10/2025.
//

import Observation
import OrderedCollections

@Observable
final class ChatStore {
    private(set) var events: OrderedDictionary<String, ChatStoreEvent> = [:]

    func reconcileChatEventDTO(eventDto: ChatEventDTO, ownNickname: String) {
        if let index = events.index(forKey: eventDto.id) {
            eventDto.updateDomain(&events.values[index])
        } else {
            events[eventDto.id] = eventDto.toDomain(ownNickname)
        }
    }

    func addChatEvent(event: ChatStoreEvent) {
        events[event.id] = event
    }

    func updateChatEvent(id: String, updateFn: (inout ChatStoreEvent) -> Void) {
        guard let index = events.index(forKey: id) else { return }
        updateFn(&events.values[index])
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
