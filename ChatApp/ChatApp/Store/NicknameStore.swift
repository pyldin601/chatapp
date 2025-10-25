//
//  NicknameStore.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI
import Observation

let NICKNAME_KEY: String = "nickname"

@Observable
final class NicknameStore {

    private(set) var nickname: String = UserDefaults.standard.string(forKey: NICKNAME_KEY) ?? ""
    
    func setNickname(_ nickname: String) {
        self.nickname = nickname
        
        UserDefaults.standard.set(nickname, forKey: NICKNAME_KEY)
    }
    
}
