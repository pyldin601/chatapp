//
//  ChatView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var vm: ChatViewModel
    
    init(nickname: String) {
        _vm = StateObject(wrappedValue: ChatViewModel(nickname: nickname))
    }
    
    var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    MessageListView(messages: vm.messages)
                }
            }
            .background(Color(UIColor.systemBackground))
            .padding(.vertical)
            .onChange(of: vm.messages.count) {
                scrollToLastMessage(proxy: proxy)
            }
        }
    }
    
    var body: some View {
        VStack {
            NavBarView()
            messagesView
            MessageInputView { vm.sendMessage($0) }
        }
        .padding()
        .task { await vm.loadHistory() }
    }
    
    func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let last = vm.messages.last {
            proxy.scrollTo(last.id, anchor: .top)
        }
    }
}

#Preview {
    ChatView(nickname: "me")
}
