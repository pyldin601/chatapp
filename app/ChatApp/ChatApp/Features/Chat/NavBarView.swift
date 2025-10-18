//
//  NavBarView.swift
//  ChatApp
//
//  Created by Roman on 18/10/2025.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        ZStack {
            Text("ChatApp")
                .font(.headline)
            HStack {
                Button("Back", systemImage: "chevron.left") {}
                Spacer()
            }
        }
    }
}

#Preview {
    NavBarView()
}
