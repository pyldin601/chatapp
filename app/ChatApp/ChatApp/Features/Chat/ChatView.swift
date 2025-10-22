//
//  ChatView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

let BOTTOM_ELEMENT_ID = "BOTTOM"

struct Background: View {
    var body: some View {
        Image("ChatBackground").resizable().scaledToFill().ignoresSafeArea()
    }
}

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
            .background(Background())
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom) {
                MessageInputView { vm.sendMessage($0) }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
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
