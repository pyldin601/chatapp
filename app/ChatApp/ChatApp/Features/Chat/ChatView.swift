//
//  ChatView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var vm: ChatAppViewModel

    var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    EventListView(messages: vm.messages)
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
            messagesView
            MessageInputView { vm.sendMessage($0) }
        }
        .padding()
    }
    
    func scrollToLastMessage(proxy: ScrollViewProxy) {
        withAnimation(.spring()) {
            if let last = vm.messages.last {
                proxy.scrollTo(last.id, anchor: .top)
            }
        }
    }
}

#Preview {
    ChatView(vm: ChatAppViewModel())
}
