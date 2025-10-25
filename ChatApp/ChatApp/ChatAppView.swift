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
    @Bindable private var vm: ChatAppViewModel2
    @State private var path = NavigationPath()
    
    init(vm: ChatAppViewModel2) {
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
                    ChatView2(vm: vm)
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
    
    let vm = ChatAppViewModel2(
        chatEventRepository: chatEventRepository,
        chatStore: chatStore,
        nicknameStore: nicknameStore
    )

    return ChatAppView(vm: vm)
}
