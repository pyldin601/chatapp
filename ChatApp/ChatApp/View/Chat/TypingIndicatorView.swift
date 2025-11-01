//
//  TypingIndicatorView.swift
//  ChatApp
//
//  Created by Roman on 01/11/2025.
//

import SwiftUI

struct TypingIndicatorView: View {
    let names: [String]

    var body: some View {
            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.thinMaterial, in: Capsule())
                .accessibilityLabel(message)
    }

    private var message: String {
        switch names.count {
        case 0: return ""
        case 1: return "\(names[0]) is typing…"
        case 2: return "\(names[0]) and \(names[1]) are typing…"
        default:
            let firstTwo = names.prefix(2).joined(separator: ", ")
            return "\(firstTwo) and others are typing…"
        }
    }
}

#Preview {
    VStack{
        TypingIndicatorView(names: ["foo"])
        TypingIndicatorView(names: ["foo", "bar"])
        TypingIndicatorView(names: ["bazz", "qux", "corge"])
    }
}
