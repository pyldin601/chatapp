//
//  NicknameChangeView.swift
//  ChatApp
//
//  Created by Roman on 25/10/2025.
//

import SwiftUI

struct ChangedNicknameEventView: View {
    let event: ChatStoreEventChangedNickname

    var body: some View {
        HStack {
            Spacer()
            Text("User **\(event.oldNickname)** changed nickname to **\(event.newNickname)**")
                .font(.caption)
            Spacer()
        }
    }
}

#Preview {
    ChangedNicknameEventView(event: ChatStoreEventChangedNickname(
        id: UUID().uuidString,
        oldNickname: "foo",
        newNickname: "bar",
        createdAt: Date()
    ))
}
