//
//  NicknameChangeView.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI

struct NicknameChangeEventView: View {
    let event: ChatStoreEvent.NicknameChange

    var body: some View {
        HStack {
            Spacer()
            Text("User **\(event.oldNickname)** changed nickname to **\(event.newNickname)**")
                .font(.caption)
                .foregroundStyle(.gray)
            Spacer()
        }
    }
}

#Preview {
    NicknameChangeEventView(event: ChatStoreEvent.NicknameChange(
        id: UUID().uuidString,
        oldNickname: "foo",
        newNickname: "bar",
        createdAt: Date()
    ))
}
