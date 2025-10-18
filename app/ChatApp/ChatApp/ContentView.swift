//
//  ContentView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let nickname: String;
    let body: String;
}

struct ContentView: View {
    @State private var messages: [Message]
    
    init(initialMessages: [Message]) {
        _messages = State(initialValue: initialMessages)
    }
    
    var navBar: some View {
        ZStack {
            Text("ChatApp")
                .font(.headline)
            HStack {
                Button("Back", systemImage: "chevron.left") {}
                Spacer()
            }
        }
    }
    
    var messagesBar: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { msg in
                        HStack {
                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(msg.nickname).font(.caption)
                                    Text(msg.body)
                                }.padding(8)
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.secondary.opacity(0.12))
                            )
                            Spacer().frame(maxWidth: 32)
                        }
                    }
                }
            }.padding(.vertical)
        }
    }
    
    var inputBar: some View {
        HStack {
            TextField("Type a message", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button("Send", systemImage: "paperplane") {}.disabled(true)
        }
    }
    
    var body: some View {
        VStack {
            navBar
            messagesBar
            inputBar
        }
        .padding()
    }
}

#Preview {
    let initialMessages = [
        Message(nickname: "johndoe", body: "Hello, world!"),
        Message(nickname: "alice", body: "Hey John 👋 How’s it going?"),
        Message(nickname: "johndoe", body: "All good! Just testing this new chat UI 😎"),
        Message(nickname: "alice", body: "Looks clean! Did you build it with SwiftUI?"),
        Message(nickname: "johndoe", body: "Yep, and it works surprisingly well on the first try 🎉"),
    ];
    
    return ContentView(initialMessages: initialMessages)
}
