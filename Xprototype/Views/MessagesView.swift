//
//  MessagesView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct MessagesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Content goes here
            }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MessagesView()
    }
}

