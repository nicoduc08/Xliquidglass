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

// MARK: - Selected Row Anchor Key
struct SelectedRowAnchorKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

// MARK: - Topic Item
struct TopicItem: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
}

// MARK: - Topic Bottom Sheet
struct TopicBottomSheet: View {
    @Binding var isShowing: Bool
    @Binding var pinnedTopics: [String]
    @Binding var feedSelectedTab: Int
    
    @State private var seeMoreTopics: [TopicItem] = [
        TopicItem(icon: "icon-politics", title: "Politics"),
        TopicItem(icon: "icon-megaphone", title: "Iran Conflict"),
        TopicItem(icon: "icon-business", title: "Business & Finance"),
        TopicItem(icon: "icon-science", title: "Science & Technology"),
        TopicItem(icon: "icon-entertainment", title: "Entertainments & Arts"),
        TopicItem(icon: "icon-AI", title: "Artificial Intelligence"),
        TopicItem(icon: "icon-gaming", title: "Gaming"),
        TopicItem(icon: "icon-cryptocurrency", title: "Crypto")
    ]
    @State private var seeLessTopics: [TopicItem] = []
    @State private var selectedTopic: TopicItem? = nil
    @State private var tooltipVisible = false
    
    @State private var sheetHeight: CGFloat = 700
    
    private var sheetBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0x14/255, green: 0x14/255, blue: 0x14/255, alpha: 1)
                : .systemBackground
        })
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Dimmed overlay
            Color.black.opacity(isShowing ? 0.4 : 0)
                .ignoresSafeArea()
                .animation(.spring(duration: 0.2), value: isShowing)
                .onTapGesture {
                    if selectedTopic != nil {
                        withAnimation(.easeOut(duration: 0.15)) { selectedTopic = nil }
                    } else {
                        isShowing = false
                    }
                }
            
            // Sheet content
            VStack(alignment: .leading, spacing: 0) {
                    // Drag handle
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color(.label).opacity(0.12))
                            .frame(width: 36, height: 5)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                    
                    // Title bar
                    ZStack(alignment: .center) {
                        Text("Customize your timeline")
                            .font(.chirpBold(size: 17))
                            .frame(maxWidth: .infinity)
                        
                        if !seeLessTopics.isEmpty {
                            HStack {
                                Spacer()
                                Button {
                                    isShowing = false
                                } label: {
                                    Text("Apply")
                                        .font(.chirpMedium(size: 15))
                                        .foregroundStyle(Color(.label))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // See more of section
                        if !seeMoreTopics.isEmpty {
                            ForEach(seeMoreTopics) { topic in
                                topicRow(topic: topic, isSeeMore: true)
                            }
                        }
                        
                        // See less of section
                        if !seeLessTopics.isEmpty {
                            Text("See less of")
                                .font(.chirpBold(size: 15))
                                .foregroundStyle(Color(.label))
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 8)
                            
                            ForEach(seeLessTopics) { topic in
                                topicRow(topic: topic, isSeeMore: false)
                            }
                        }
                    }
                }
            .padding(.bottom, 22)
            .overlayPreferenceValue(SelectedRowAnchorKey.self) { anchor in
                ZStack {
                    // Dim layer
                    Color.black.opacity(tooltipVisible ? 0.1 : 0)
                        .animation(.easeInOut(duration: 0.15), value: tooltipVisible)
                        .ignoresSafeArea()
                        .allowsHitTesting(tooltipVisible)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.15)) { tooltipVisible = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { selectedTopic = nil }
                        }
                        .zIndex(0)
                    
                    // Tooltip on top
                    if let anchor, let topic = selectedTopic {
                        GeometryReader { proxy in
                            let rect = proxy[anchor]
                            VStack(alignment: .leading, spacing: 0) {
                                tooltipButton(icon: "icon-pin", label: "Pin to timeline") {
                                    let topicTitle = topic.title
                                    withAnimation(.spring(duration: 0.15)) { tooltipVisible = false }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        selectedTopic = nil
                                        if !pinnedTopics.contains(topicTitle) {
                                            pinnedTopics.append(topicTitle)
                                        }
                                        // Select the new pinned tab (id = 100 + index)
                                        let tabIndex = pinnedTopics.firstIndex(of: topicTitle) ?? 0
                                        feedSelectedTab = 100 + tabIndex
                                        isShowing = false
                                    }
                                }
                                Divider().padding(.horizontal, 12)
                                tooltipButton(icon: "icon-arrow-down", label: "Move to see less") {
                                    withAnimation(.spring(duration: 0.15)) { tooltipVisible = false }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        selectedTopic = nil
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if let index = seeMoreTopics.firstIndex(of: topic) {
                                                let removed = seeMoreTopics.remove(at: index)
                                                seeLessTopics.append(removed)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: 190)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                            )
                            .scaleEffect(tooltipVisible ? 1 : 0.01, anchor: .topLeading)
                            .opacity(tooltipVisible ? 1 : 0)
                            .animation(.spring(duration: 0.15), value: tooltipVisible)
                            .position(x: rect.minX + 130, y: rect.maxY + 40)
                        }
                        .zIndex(1)
                    }
                }
            }
            .background(
                GeometryReader { geo in
                    UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30)
                        .fill(sheetBackground)
                        .ignoresSafeArea(edges: .bottom)
                        .onAppear { sheetHeight = geo.size.height }
                        .onChange(of: seeMoreTopics.count) { sheetHeight = geo.size.height }
                        .onChange(of: seeLessTopics.count) { sheetHeight = geo.size.height }
                }
            )
            .ignoresSafeArea(edges: .bottom)
            .offset(y: isShowing ? 0 : sheetHeight + 50)
            .animation(.spring(duration: 0.2), value: isShowing)
        }
        .allowsHitTesting(isShowing)
    }
    
    @ViewBuilder
    private func tooltipButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.label))
                Text(label)
                    .font(.chirpMedium(size: 16))
                    .foregroundStyle(Color(.label))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func topicRow(topic: TopicItem, isSeeMore: Bool) -> some View {
        HStack(spacing: 14) {
            Image(topic.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(.label))
            
            Text(topic.title)
                .font(.chirpMedium(size: 15))
                .foregroundStyle(Color(.label))
            
            Spacer()
            
            Image(isSeeMore ? (pinnedTopics.contains(topic.title) ? "icon-pin" : "icon-more") : "icon-exclude")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(Color(.label))
        }
        .padding(.horizontal, 20)
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            if isSeeMore {
                if pinnedTopics.contains(topic.title) {
                    // Tapping a pinned topic: unpin it and dismiss the sheet
                    if let pinIndex = pinnedTopics.firstIndex(of: topic.title) {
                        let removedTabId = 100 + pinIndex
                        withAnimation(.easeInOut(duration: 0.25)) {
                            pinnedTopics.remove(at: pinIndex)
                        }
                        if feedSelectedTab == removedTabId {
                            feedSelectedTab = 0
                        }
                    }
                    isShowing = false
                } else if selectedTopic == topic {
                    withAnimation(.spring(duration: 0.15)) { tooltipVisible = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { selectedTopic = nil }
                } else {
                    selectedTopic = topic
                    tooltipVisible = false
                    withAnimation(.spring(duration: 0.15)) { tooltipVisible = true }
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if let index = seeLessTopics.firstIndex(of: topic) {
                        let removed = seeLessTopics.remove(at: index)
                        seeMoreTopics.append(removed)
                    }
                }
            }
        }
        .anchorPreference(key: SelectedRowAnchorKey.self, value: .bounds) { anchor in
            (isSeeMore && selectedTopic == topic) ? anchor : nil
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    NavigationStack {
        FeedView(isSidebarShowing: .constant(false), isTopicSheetShowing: .constant(false), pinnedTopics: .constant([]), selectedTab: .constant(0))
    }
}
