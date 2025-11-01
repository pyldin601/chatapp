//
//  ChatAppView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI
import OrderedCollections
import Observation

enum Route: Hashable {
    case chat
}

struct ChatAppView: View {
    @Bindable private var vm: ChatAppViewModel
    @State private var path = NavigationPath()
    
    init(vm: ChatAppViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(vm: vm, nickname: vm.nicknameStore.nickname) {
                path.append(Route.chat)
            }
            .padding()
            .navigationTitle("ChatApp")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .chat:
                    ChatView(vm: vm)
                        .toolbarBackground(.visible)
                        .ignoresSafeArea(.container)
                }
            }
        }
        .onAppear { vm.connect() }
        .onDisappear { vm.disconnect() }
    }
}

#Preview {
    let chatEventRepository = FirebaseChatEventRepositoryImpl()
    let chatStore = ChatStore()
    let nicknameStore = NicknameStore()
    let typingIndicatorStore = TypingIndicatorStore()
    
    let vm = ChatAppViewModel(
        chatEventRepository: chatEventRepository,
        chatStore: chatStore,
        nicknameStore: nicknameStore,
        typingIndicatorStore: typingIndicatorStore
    )

    return ChatAppView(vm: vm)
}
