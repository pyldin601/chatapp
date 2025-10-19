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
                    Spacer(minLength: 40)
                }
            }
            .background(Color(UIColor.systemBackground))
            .padding(.vertical)
            .onChange(of: vm.messages.count) {
                withAnimation() {
                    scrollToLastMessage(proxy: proxy)
                }
            }
            .onAppear() {
                scrollToLastMessage(proxy: proxy)
            }
        }
    }
    
    var body: some View {
        ZStack {
            messagesView
            VStack {
                Spacer()
                MessageInputView { msg in vm.sendMessage(msg) }
            }
            
        }
        .padding()
    }
    
    func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let last = vm.messages.last {
            proxy.scrollTo(last.id, anchor: .top)
        }
    }
}

#Preview {
    ChatView(vm: ChatAppViewModel())
}
