//
//  NicknameStore.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI
import Combine

let NICKNAME_KEY: String = "nickname"

@MainActor
final class NicknameStore: ObservableObject {

    @Published private(set) var nickname: String = UserDefaults.standard.string(forKey: NICKNAME_KEY) ?? ""
    
    func setNickname(_ nickname: String) {
        self.nickname = nickname
        
        UserDefaults.standard.set(nickname, forKey: NICKNAME_KEY)
    }
    
}
