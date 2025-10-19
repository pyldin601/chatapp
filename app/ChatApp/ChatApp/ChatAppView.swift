//
//  ChatAppView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

enum Route: Hashable {
    case chat
}

struct ChatAppView: View {
    @StateObject private var vm: ChatAppViewModel
    @State private var path = NavigationPath()
    
    init(vm: ChatAppViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView(vm: vm, nickname: vm.nickname) {
                path.append(Route.chat)
            }
            .padding()
            .navigationTitle("Enter")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .chat:
                    ChatView(vm: vm).navigationTitle("Chat")
                }
            }
        }
        .onAppear {
            Task { await vm.subscribe() }
        }
        .onDisappear {
            Task { await vm.unsubscribe() }
        }
    }
}

#Preview {
    ChatAppView(vm: ChatAppViewModel())
}
