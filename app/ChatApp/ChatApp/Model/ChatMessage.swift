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
    let originalBody: String;
    let isOwn: Bool
}

func htmlToAttributed(_ html: String, color: Color = .primary) -> AttributedString {
    // TODO: customize styles
    let wrappedHtml = "<span style=\"font-family: -apple-system; font-size: 16px;\">\(html)</span>"

    guard let data = wrappedHtml.data(using: .utf8) else { return AttributedString("") }

        guard let nsAttr = try? NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) else { return AttributedString("") }

        // Apply color to the whole range
        nsAttr.addAttribute(.foregroundColor, value: UIColor(color), range: NSRange(location: 0, length: nsAttr.length))

        return AttributedString(nsAttr)
}

func makeChatMessage(nickname: String, body: String, isOwn: Bool) -> ChatMessage {
    let str = htmlToAttributed(body)
    
    return ChatMessage(nickname: nickname, body: str, originalBody: body, isOwn: isOwn)
}
