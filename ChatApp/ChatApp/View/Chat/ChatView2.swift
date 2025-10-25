//
//  ChatView2.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI
import OrderedCollections

let BOTTOM_ELEMENT_ID2 = "BOTTOM"

struct Background2: View {
    var body: some View {
        GeometryReader { geometry in
            Image("ChatBackground")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ChatView2: View {
    @Bindable var vm: ChatAppViewModel2
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    
                    ChatEventsView(events: vm.chatStore.events.values)
                    Color.clear
                        .frame(height: 1)
                        .id(BOTTOM_ELEMENT_ID2)
                }
                .padding(.horizontal)
            }
            .background(Background2())
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom) {
                MessageInputView { vm.sendMessage($0) }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                    .background(.clear)
            }
            .onChange(of: vm.chatStore.events.count) {
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
        proxy.scrollTo(BOTTOM_ELEMENT_ID2, anchor: .top)
    }
}

//#Preview {
//    ChatView2(events: [
//        .message(ChatStoreEventMessage(
//            id: UUID().uuidString,
//            nickname: "john",
//            text: "Hello, world!\nHello, world!",
//            direction: .incoming,
//            deliveryStatus: .delivered,
//            createdAt: Date()
//        )),
//        .changedNickname(ChatStoreEventChangedNickname(
//            id: UUID().uuidString,
//            oldNickname: "foo",
//            newNickname: "bar",
//            createdAt: Date()
//        )),
//        .message(ChatStoreEventMessage(
//            id: UUID().uuidString,
//            nickname: "bar",
//            text: "Hello, world! - Pending",
//            direction: .outgoing,
//            deliveryStatus: .pending,
//            createdAt: Date()
//        ))
//    ]) { text in
//        print("Sending message...", text)
//    }.ignoresSafeArea()
//}
