//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let nickname: String;
    let body: AttributedString;
    let isOwn: Bool
}

func htmlToAttributed(_ html: String) -> AttributedString {
    // TODO: customize styles
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

func makeChatMessage(nickname: String, body: String, isOwn: Bool) -> ChatMessage {
    ChatMessage(nickname: nickname, body: htmlToAttributed(body), isOwn: isOwn)
}
