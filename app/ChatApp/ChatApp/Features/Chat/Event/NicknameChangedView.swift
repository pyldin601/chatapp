//
//  NicknameChangedView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct NicknameChangedView: View {
    let event: NicknameChangedEvent
    
    var body: some View {
        HStack {
            Spacer()
            Text("User **\(event.oldNickname)**  changed nickname to **\(event.newNickname)**")
                .font(.caption)
            Spacer()
        }
    }
}

#Preview {
    NicknameChangedView(event: NicknameChangedEvent(oldNickname: "foo", newNickname: "bar"))
}
