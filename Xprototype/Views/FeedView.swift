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
    @Namespace private var postTransition
    
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
    
    // Header height: single row with glass buttons + padding
    private let headerHeight: CGFloat = 52
    
    var body: some View {
        let totalHeaderHeight = safeAreaTop + headerHeight

        ZStack(alignment: .top) {
            ScrollViewWithHeader(headerOffset: $headerOffset, safeAreaTop: safeAreaTop, safeAreaBottom: safeAreaBottom, headerHeight: headerHeight) {
                LazyVStack(spacing: 0, pinnedViews: []) {
                    ForEach(posts) { post in
                        NavigationLink {
                            PostDetailView(post: post)
                                .navigationTransition(.zoom(sourceID: post.id, in: postTransition))
                        } label: {
                            PostCell(post: post)
                                .matchedTransitionSource(id: post.id, in: postTransition) { source in
                                    source
                                        .background(Color(.systemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 0))
                                        .shadow(color: .clear, radius: 0)
                                }
                        }
                        .buttonStyle(.plain)
                        Rectangle()
                            .fill(Color(.label).opacity(0.15))
                            .frame(height: 0.5)
                    }
                }
                .offset(y: -safeAreaTop - 20)
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
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    // Only respond to swipes starting near the left edge
                    guard value.startLocation.x < 40 else { return }
                    if value.translation.width > 80 || value.predictedEndTranslation.width > 150 {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isSidebarShowing = true
                        }
                    }
                }
        )
    }
}

#Preview {
    NavigationStack {
        FeedView(isSidebarShowing: .constant(false))
    }
}
