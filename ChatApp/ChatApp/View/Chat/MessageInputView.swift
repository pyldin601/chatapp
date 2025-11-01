//
//  MessageInputView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI
import Combine

final class MessageInputVM: ObservableObject {
    @Published var draft = ""
    @Published private(set) var isNotEmpty = false
    
    private var bag = Set<AnyCancellable>()
    
    var onTyping: (() -> Void)?
    
    private var isNonEmpty: (String) -> Bool {
        { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    init() {
        $draft
            .map(isNonEmpty)
            .assign(to: &$isNotEmpty)
        
        $draft
            .removeDuplicates()
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
            .filter(isNonEmpty)
            .sink { [weak self] _ in self?.onTyping?() }
            .store(in: &bag)
    }
}

struct MessageInputView: View {
    let onSend: (String) -> Void
    let onTyping: () -> Void
    
    @StateObject private var vm = MessageInputVM()
    
    var body: some View {
        HStack {
            HStack {
                TextField("Type a message", text: $vm.draft)
                    .textFieldStyle(.plain)
                    .frame(height: 50)
                    .padding(.horizontal, 18)
                    .glassEffect(.regular.interactive())
                    .onAppear {
                        vm.onTyping = onTyping
                    }
                
                Spacer()
                
                Button(action: onSendButtonClick) {
                    Image(systemName: "paperplane")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 50, height: 50)
                .glassEffect(.regular.interactive())
                .disabled(!vm.isNotEmpty)
            }
            .padding()
        }
    }
    
    private func onSendButtonClick() {
        onSend(vm.draft)
        vm.draft = ""
    }
}

#Preview {
    MessageInputView(
        onSend: { text in
            print("Sent '\(text)'")
        },
        onTyping: {
            print("Typing message...")
        },
    )
}
