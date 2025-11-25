//
//  GrokView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct GrokView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Grok")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .navigationTitle("Grok")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GrokView()
    }
}

