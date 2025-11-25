//
//  ExploreView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Explore")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}

