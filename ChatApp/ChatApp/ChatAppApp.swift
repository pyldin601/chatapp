//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct ChatAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let chatEventRepository = FirebaseChatEventRepositoryImpl()
            let chatStore = ChatStore()
            let nicknameStore = NicknameStore()
            
            let vm = ChatAppViewModel(
                chatEventRepository: chatEventRepository,
                chatStore: chatStore,
                nicknameStore: nicknameStore
            )
            
            ChatAppView(vm: vm)
        }
    }
}
