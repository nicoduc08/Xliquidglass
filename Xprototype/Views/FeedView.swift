//
//  FeedView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

// FeedView.swift
import SwiftUI

struct FeedView: View {
    @Binding var isSidebarShowing: Bool
    
    private let posts = Post.mock
    @State private var selectedTab = 0
    @State private var headerOffset: CGFloat = 0
    
    // Get actual device safe area from window
    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
    
    private var safeAreaBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    // Header height includes avatar row (32 + 6), tabs (44), and divider (1)
    private let headerHeight: CGFloat = 83
    
    var body: some View {
        let totalHeaderHeight = safeAreaTop + headerHeight

        ZStack(alignment: .top) {
            ScrollViewWithHeader(headerOffset: $headerOffset, safeAreaTop: safeAreaTop, safeAreaBottom: safeAreaBottom, headerHeight: headerHeight) {
                LazyVStack(spacing: 0, pinnedViews: []) {
                    ForEach(posts) { post in
                        PostCell(post: post)
                        Divider()
                    }
                }
            }
            
            // Header
            FeedHeader(selectedTab: $selectedTab, safeAreaTop: safeAreaTop) {
                withAnimation(.easeOut(duration: 0.25)) {
                    isSidebarShowing = true
                }
            }
            .offset(y: headerOffset)
            .opacity(max(0.0, 1.0 + (headerOffset / totalHeaderHeight)))
            .allowsHitTesting(headerOffset >= -44)
            .zIndex(1)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: [.top, .bottom])
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        FeedView(isSidebarShowing: .constant(false))
    }
}
