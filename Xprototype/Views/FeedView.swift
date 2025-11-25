//
//  FeedView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

// FeedView.swift
import SwiftUI

struct FeedView: View {
    private let posts = Post.mock
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: []) {
                ForEach(posts) { post in
                    PostCell(post: post)
                    Divider()
                }
            }
        }
        .background(Color(.systemBackground))
        
        // ←←← THE MAGIC COMBO (copy exactly)
        .navigationTitle("Home")                          // Needed for large-title scroll behavior
        .navigationBarTitleDisplayMode(.inline)           // Enables the progressive blur
        .toolbar {
            ToolbarItem(placement: .principal) {
                // Invisible placeholder – hides the text but keeps blur alive
                Color.clear
                    .frame(height: 0)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
