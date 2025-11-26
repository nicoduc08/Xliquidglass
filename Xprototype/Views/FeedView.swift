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
    @State private var selectedTab = 0
    @State private var headerOffset: CGFloat = 0
    
    // Get actual device safe area from window
    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
    
    private let headerHeight: CGFloat = 44
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollViewWithHeader(headerOffset: $headerOffset, safeAreaTop: safeAreaTop, headerHeight: headerHeight) {
                LazyVStack(spacing: 0, pinnedViews: []) {
                    ForEach(posts) { post in
                        PostCell(post: post)
                        Divider()
                    }
                }
            }
            
            // Header
            FeedHeader(selectedTab: $selectedTab, safeAreaTop: safeAreaTop)
                .offset(y: headerOffset)
                .opacity(max(0.0, 1.0 + (headerOffset / 96.0)))
                .allowsHitTesting(headerOffset >= -44)
                .zIndex(1)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
