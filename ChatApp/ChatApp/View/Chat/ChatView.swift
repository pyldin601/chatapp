//
//  ChatView2.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI
import OrderedCollections

let BOTTOM_ELEMENT_ID = "BOTTOM"

struct Background: View {
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

struct ChatView: View {
    @Bindable var vm: ChatAppViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ChatEventsView(events: vm.chatStore.events.values)
                            Color.clear
                                .frame(height: 1)
                                .id(BOTTOM_ELEMENT_ID)
                        }
                        .frame(minHeight: geo.size.height, alignment: .bottom)
                        .padding(.horizontal)
                    }
                    .background(Background())
                    .scrollDismissesKeyboard(.interactively)
                    .onAppear() {
                        DispatchQueue.main.async {
                            scrollToBottom(proxy: proxy)
                        }
                    }
                    .onChange(of: vm.chatStore.events.count) {
                        withAnimation() {
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
        }
        .safeAreaInset(edge: .bottom) {
            MessageInputView { vm.sendMessage($0) }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
                .background(.clear)
        }
        
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo(BOTTOM_ELEMENT_ID, anchor: .top)
    }
}

#Preview {
    ChatView(vm: createPreviewVM()).ignoresSafeArea()
}
