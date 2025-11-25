//
//  NotificationsView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Notifications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}

