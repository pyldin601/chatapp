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
    let body: AttributedString;
}

@MainActor
func htmlToAttributed(_ html: String) -> AttributedString {
    let wrappedHtml = "<span style=\"font-family: -apple-system; font-size: 16px;\">\(html)</span>"
    guard let data = wrappedHtml.data(using: .utf8) else { return AttributedString("") }

    if let nsAttr = try? NSAttributedString(
        data: data,
        options: [.documentType: NSAttributedString.DocumentType.html,
                  .characterEncoding: String.Encoding.utf8.rawValue],
        documentAttributes: nil
    ) {
        return AttributedString(nsAttr)
    }

    return AttributedString("")
}

@MainActor
func makeMessage(nickname: String, body: String) -> Message {
    Message(nickname: nickname, body: htmlToAttributed(body))
}

struct ContentView: View {
    @State private var messages: [Message]
    @State private var draft: String = ""
    
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
            }
            .background(Color(UIColor.systemBackground))
            .padding(.vertical)
            .onChange(of: messages.count) {
                // scroll to the newest item (which is "top" due to inversion, but visually bottom)
                if let last = messages.last {
                    withAnimation(.easeOut) {
                        proxy.scrollTo(last.id, anchor: .top)
                    }
                }
            }
            .onAppear {
                if let last = messages.last {
                    proxy.scrollTo(last.id, anchor: .top)
                }
            }
        }
    }
    
    var inputBar: some View {
        HStack {
            TextField("Type a message", text: $draft)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button("Send", systemImage: "paperplane") {
                let newMessage = makeMessage(nickname: "me", body: draft)
                messages.append(newMessage)
                draft = ""
            }.disabled(
                draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
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
        makeMessage(nickname: "johndoe", body: "Hello, world!"),
        makeMessage(nickname: "alice", body: "Hey John 👋 How’s it going?"),
        makeMessage(nickname: "johndoe", body: "All good! Just testing this new chat UI 😎"),
        makeMessage(nickname: "alice", body: "Looks clean! Did you build it with SwiftUI?"),
        makeMessage(nickname: "johndoe", body: "Yep, and it works surprisingly well on the first try 🎉"),
        makeMessage(nickname: "alice", body: "Does it support HTML markdown?"),
        makeMessage(nickname: "johndoe", body: "Sure, <i>this</i> is italic and <b>this</b> is bold!"),
    ];
    
    return ContentView(initialMessages: initialMessages)
}
