//
//  TypingIndicatorStore.swift
//  ChatApp
//
//  Created by Roman on 01/11/2025.
//

import SwiftUI
import Observation
import Combine

@Observable
final class TypingIndicatorStore {
    private(set) var active: [String: Date] = [:]
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in self?.pruneExpired(at: now) }
            .store(in: &bag)
    }
    
    func markTyping(nickname: String, eventTime: Date) {
        let expireAt = eventTime.addingTimeInterval(10)
        active[nickname] = expireAt
    }
    
    func unmarkTyping(nickname: String) {
        active.removeValue(forKey: nickname)
    }
    
    private func pruneExpired(at now: Date) {
        active = active.filter { _, expiresAt in expiresAt > now }
    }
    
    var activeNames: [String] {
        Array(active.keys).sorted()
    }
}
