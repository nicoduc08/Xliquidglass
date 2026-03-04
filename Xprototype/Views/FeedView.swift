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
    @Binding var isTopicSheetShowing: Bool
    @Binding var pinnedTopics: [String]
    @Binding var selectedTab: Int
    @Namespace private var postTransition
    
    private let posts = Post.mock
    @State private var headerOffset: CGFloat = 0
    @State private var isLoadingTimeline = false
    @State private var displayedPosts: [Post] = Post.mock
    @State private var lastSelectedTab = 0
    
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
    
    // Header height: avatar row + tab row + divider
    private let headerHeight: CGFloat = 80
    
    var body: some View {
        let totalHeaderHeight = safeAreaTop + headerHeight

        ZStack(alignment: .top) {
            ScrollViewWithHeader(headerOffset: $headerOffset, safeAreaTop: safeAreaTop, safeAreaBottom: safeAreaBottom, headerHeight: headerHeight) {
                LazyVStack(spacing: 0, pinnedViews: []) {
                    ForEach(displayedPosts) { post in
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
                .opacity(isLoadingTimeline ? 0 : 1)
            }
            
            // Loading spinner
            if isLoadingTimeline {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(Color(.label))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            }
            
            // Header
            FeedHeader(
                selectedTab: $selectedTab,
                safeAreaTop: safeAreaTop,
                pinnedTopics: $pinnedTopics,
                onAvatarTap: {
                    withAnimation(.easeOut(duration: 0.25)) {
                        isSidebarShowing = true
                    }
                },
                onBellTap: {
                    isTopicSheetShowing = true
                }
            )
            .offset(y: headerOffset)
            .opacity(max(0.0, 1.0 + (headerOffset / totalHeaderHeight)))
            .allowsHitTesting(headerOffset >= -44)
            .zIndex(1)
            
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: [.top, .bottom])
        .navigationBarHidden(true)
        .onChange(of: selectedTab) { oldValue, newValue in
            // Only trigger loading for pinned tabs or when switching between different tabs
            if newValue != oldValue {
                if newValue >= 100 {
                    // Pinned tab: show spinner and load shuffled posts
                    isLoadingTimeline = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            displayedPosts = posts.shuffled()
                            isLoadingTimeline = false
                        }
                    }
                } else {
                    // Standard tab: restore original posts
                    if oldValue >= 100 {
                        isLoadingTimeline = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                displayedPosts = posts
                                isLoadingTimeline = false
                            }
                        }
                    }
                }
            }
        }
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

// MARK: - Removed SelectedRowAnchorKey
// This was used for the complex tooltip system that was removed

// MARK: - Removed TopicBottomSheet
// This was the old complex sheet implementation that was replaced with TopicSheetContent

#Preview {
    NavigationStack {
        FeedView(isSidebarShowing: .constant(false), isTopicSheetShowing: .constant(false), pinnedTopics: .constant([]), selectedTab: .constant(0))
    }
}
