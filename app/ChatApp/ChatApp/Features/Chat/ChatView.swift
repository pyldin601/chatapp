//
//  ChatView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

let BOTTOM_ELEMENT_ID = "BOTTOM"

struct ChatView: View {
    @ObservedObject var vm: ChatAppViewModel
    
    var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    EventListView(messages: vm.messages)
                    Spacer(minLength: 32)
                    Color.clear
                        .frame(height: 1)
                        .id(BOTTOM_ELEMENT_ID)
                }
            }
            .background(Color(UIColor.systemBackground))
            .padding(.vertical)
            .onChange(of: vm.messages.count) {
                withAnimation() {
                    scrollToBottom(proxy: proxy)
                }
            }
            .onAppear() {
                scrollToBottom(proxy: proxy)
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
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo(BOTTOM_ELEMENT_ID, anchor: .top)
    }
    
    func scrollToMessage(proxy: ScrollViewProxy, id: String) {
        proxy.scrollTo(id, anchor: .top)
    }
}

#Preview {
    ChatView(vm: ChatAppViewModel())
}
