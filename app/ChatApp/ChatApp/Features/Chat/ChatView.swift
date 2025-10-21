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
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    EventListView(messages: vm.messages)
                    
                    Color.clear
                        .frame(height: 1)
                        .id(BOTTOM_ELEMENT_ID)
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemBackground))
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom) {
                MessageInputView { vm.sendMessage($0) }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .background(.clear)
            }
            .onChange(of: vm.messages.count) {
                DispatchQueue.main.async {
                    withAnimation() {
                        scrollToBottom(proxy: proxy)
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.async {
                    scrollToBottom(proxy: proxy)
                }
            }
            .onReceive(NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillChangeFrameNotification
            )) { _ in
                withAnimation() {
                    scrollToBottom(proxy: proxy)
                }
            }
        }
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
        .ignoresSafeArea()
}
