//
//  TypingIndicatorView.swift
//  ChatApp
//
//  Created by Roman on 01/11/2025.
//

import SwiftUI

struct TypingIndicatorView: View {
    let names: [String]
    
    @State var visibleNames: [String] = []
    
    var body: some View {
        Group {
            Text(message)
                .font(.footnote)
                .foregroundStyle(.gray)
                .accessibilityLabel(message)
        }
        .opacity(names.isEmpty ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: names.isEmpty)
        .onAppear { visibleNames = names }
        .onChange(of: names) { _, newNames in
            guard !newNames.isEmpty else { return }
            visibleNames = newNames
        }
    }
    
    private var message: String {
        switch visibleNames.count {
        case 1: return "\(visibleNames[0]) is typing…"
        case 2: return "\(visibleNames[0]) and \(visibleNames[1]) are typing…"
        default:
            let firstTwo = visibleNames.prefix(2).joined(separator: ", ")
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
