//
//  MainTabView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

// MainTabView.swift
import SwiftUI
import UIKit

struct MainTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab = 0
    @State private var isSidebarShowing = false
    @State private var isSettingsShowing = false
    @State private var isPremiumShowing = false
    @State private var isComposerShowing = false
    @State private var lastSelectedTab = 0
    @State private var isInDetailView = false
    @State private var sidebarDragOffset: CGFloat = 0
    
    // Sidebar width for content offset
    private var sidebarWidth: CGFloat {
    
        UIScreen.main.bounds.width * 0.78
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            // Sidebar (undern eath main content)
            SidebarView(isShowing: $isSidebarShowing, isSettingsShowing: $isSettingsShowing, isPremiumShowing: $isPremiumShowing, user: .current, dragOffset: sidebarDragOffset)
            
            // Main tab content
            TabView(selection: $selectedTab) {
                Tab(value: 0) {
                    FeedView(isSidebarShowing: $isSidebarShowing, isInDetailView: $isInDetailView, isDraggingSidebar: sidebarDragOffset > 10)
                } label: {
                    tabIcon("icon-home", title: "", tag: 0)
                }

                Tab(value: 1) {
                    NavigationStack { ExploreView() }
                } label: {
                    tabIcon("icon-explore", title: "", tag: 1)
                }

                Tab(value: 2) {
                    NavigationStack { NotificationsView() }
                } label: {
                    tabIcon("icon-bell", title: "", tag: 2)
                }

                Tab(value: 3) {
                    NavigationStack { MessagesView() }
                } label: {
                    tabIcon("icon-message", title: "", tag: 3)
                }

                Tab("New post", systemImage: "plus", value: 4, role: .search) {
                    Color.clear
                }
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 4 {
                    // Immediately reset to previous tab and show composer
                    withTransaction(Transaction(animation: nil)) {
                        selectedTab = oldValue
                    }
                    isComposerShowing = true
                }
            }
            .tabBarMinimizeBehavior(isInDetailView ? .never : .onScrollDown)
            .tint(colorScheme == .dark ? .white : .black)
            .overlay {
                Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white })
                    .opacity(isSidebarShowing ? 0.4 : 0.4 * max(0, (sidebarDragOffset / sidebarWidth - 0.7) / 0.3))
                    .ignoresSafeArea()
                    .allowsHitTesting(isSidebarShowing || sidebarDragOffset > 0)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isSidebarShowing = false
                        }
                    }
            }
            .shadow(color: Color(.label).opacity(isSidebarShowing || sidebarDragOffset > 0 ? (colorScheme == .dark ? 0 : 0.10) : 0), radius: 8, x: -3)
            .offset(x: isSidebarShowing ? sidebarWidth : sidebarDragOffset)
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSidebarShowing)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        // Disable sidebar drag in detail view
                        guard !isInDetailView else { return }
                        // Require very strong horizontal intent (3x more horizontal than vertical)
                        let horizontal = abs(value.translation.width)
                        let vertical = abs(value.translation.height)
                        guard horizontal > vertical * 3 else { return }
                        // Minimum 30pt before activating
                        guard horizontal > 30 else { return }
                        
                        if !isSidebarShowing {
                            guard value.translation.width > 0 else { return }
                            let drag = min(max(value.translation.width - 30, 0), sidebarWidth)
                            sidebarDragOffset = drag
                        } else {
                            guard value.translation.width < 0 else { return }
                            let drag = max(value.translation.width, -sidebarWidth)
                            sidebarDragOffset = drag
                        }
                    }
                    .onEnded { value in
                        guard !isInDetailView else { return }
                        if !isSidebarShowing {
                            if sidebarDragOffset > sidebarWidth * 0.35 || value.predictedEndTranslation.width > sidebarWidth * 0.5 {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    isSidebarShowing = true
                                    sidebarDragOffset = 0
                                }
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                    sidebarDragOffset = 0
                                }
                            }
                        } else {
                            if sidebarDragOffset < -sidebarWidth * 0.35 || value.predictedEndTranslation.width < -sidebarWidth * 0.3 {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    isSidebarShowing = false
                                    sidebarDragOffset = 0
                                }
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                    sidebarDragOffset = 0
                                }
                            }
                        }
                    }
            )
            .onChange(of: isSidebarShowing) { _, isOpen in
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
            .onAppear {
                // Configure tab bar appearance for proper dark mode support
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                UITabBar.appearance().tintColor = .label
            }
            // Settings screen - slides in from right
            if isSettingsShowing {
                SettingsView(isShowing: $isSettingsShowing, username: User.current.username)
                    .transition(.move(edge: .trailing))
            }
            
            // Premium screen - slides in from right
            if isPremiumShowing {
                PremiumView(isShowing: $isPremiumShowing, username: User.current.username)
                    .transition(.move(edge: .trailing))
            }
            
        }
        .fullScreenCover(isPresented: $isComposerShowing) {
            ComposerView()
        }
    }
    
    @ViewBuilder
    private func tabIcon(_ baseName: String, title: String, tag: Int) -> some View {
        Label(
            title: { Text(title) },
            icon: {
                Image(selectedTab == tag ? "\(baseName)-filled" : "\(baseName)-outline")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
        )
    }
}

// MARK: - Topic Item
struct TopicItem: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
}

// MARK: - Topic Sheet Content
struct TopicSheetContent: View {
    @Binding var pinnedTopics: [String]
    @Binding var feedSelectedTab: Int

    @Environment(\.dismiss) private var dismiss

    @State private var removedTopics: [TopicItem] = []

    private var hasChanges: Bool {
        !removedTopics.isEmpty
    }

    let allTopics: [TopicItem] = [
        TopicItem(icon: "icon-politics", title: "Politics"),
        TopicItem(icon: "icon-megaphone", title: "Iran Conflict"),
        TopicItem(icon: "icon-business", title: "Business & Finance"),
        TopicItem(icon: "icon-science", title: "Science & Technology"),
        TopicItem(icon: "icon-entertainment", title: "Entertainments & Arts"),
        TopicItem(icon: "icon-AI", title: "Artificial Intelligence"),
        TopicItem(icon: "icon-gaming", title: "Gaming"),
        TopicItem(icon: "icon-cryptocurrency", title: "Crypto")
    ]

    var availableTopics: [TopicItem] {
        allTopics.filter { topic in
            !removedTopics.contains(where: { $0.id == topic.id })
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Drag handle
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(.label).opacity(0.12))
                        .frame(width: 36, height: 5)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.bottom, 12)

                // Title with optional Apply button
                HStack {
                    Text("Filter timeline")
                        .font(.chirpBold(size: 23))

                    Spacer()

                    if hasChanges {
                        Button("Apply") {
                            dismiss()
                        }
                        .font(.chirpMedium(size: 15))
                        .foregroundStyle(Color(.label))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                // Topics list
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Topics included in timeline section
                        Text("Topics included in timeline")
                            .font(.chirpMedium(size: 15))
                            .foregroundStyle(Color(.label).opacity(0.4))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                        // Main topics section
                        ForEach(availableTopics) { topic in
                            topicRow(topic: topic, isRemoved: false)
                        }

                        // Removed topics section
                        if !removedTopics.isEmpty {
                            Text("Topics removed from timeline")
                                .font(.chirpMedium(size: 15))
                                .foregroundStyle(Color(.label).opacity(0.4))
                                .padding(.horizontal, 20)
                                .padding(.top, 24)
                                .padding(.bottom, 16)

                            ForEach(removedTopics) { topic in
                                topicRow(topic: topic, isRemoved: true)
                            }
                        }
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private func topicRow(topic: TopicItem, isRemoved: Bool) -> some View {
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

            Image(systemName: isRemoved ? "plus.circle" : "minus.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(isRemoved ? Color(hex: "#00BA7C") : Color(hex: "#F4212E"))
        }
        .padding(.horizontal, 20)
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            if isRemoved {
                // Move back to main section
                removedTopics.removeAll(where: { $0.id == topic.id })
            } else {
                // Move to removed section
                removedTopics.append(topic)
            }
        }
    }
}

// MARK: - Composer View
struct ComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var postText = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Top bar: Cancel | Drafts | Post
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.chirpRegular(size: 17))
                .foregroundStyle(Color(.label))

                Spacer()

                Button("Drafts") { }
                    .font(.chirpBold(size: 15))
                    .foregroundStyle(Color(hex: "#1D9BF0"))
                    .padding(.trailing, 12)

                Button {
                    // Post action
                } label: {
                    Text("Post")
                        .font(.chirpBold(size: 15))
                        .foregroundStyle(.white.opacity(postText.isEmpty ? 0.5 : 1))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(postText.isEmpty ? Color(hex: "#1D9BF0").opacity(0.5) : Color(hex: "#1D9BF0"))
                        )
                }
                .disabled(postText.isEmpty)
            }
            .padding(.leading, 32)
            .padding(.trailing, 32)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Avatar + audience + text editor
            HStack(alignment: .top, spacing: 12) {
                Image("Avatar 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    // Audience picker
                    Button {
                        // Audience picker action
                    } label: {
                        HStack(spacing: 4) {
                            Text("Everyone")
                                .font(.chirpMedium(size: 15))
                                .foregroundStyle(Color(hex: "#1D9BF0"))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color(hex: "#1D9BF0"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule().stroke(Color(.label).opacity(0.1), lineWidth: 1)
                        )
                    }

                    // Text input
                    TextField("What's happening?", text: $postText, axis: .vertical)
                        .font(.chirpRegular(size: 18))
                        .foregroundStyle(Color(.label))
                        .focused($isTextFieldFocused)
                        .lineLimit(1...20)
                }
            }
            .padding(.leading, 32)
            .padding(.trailing, 32)

            Spacer()
            
            // Reply settings
            HStack(spacing: 6) {
                Image("icon-globe")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color(hex: "#1D9BF0"))
                Text("Everyone can reply")
                    .font(.chirpRegular(size: 14))
                    .foregroundStyle(Color(hex: "#1D9BF0"))
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 12)
            
            // Bottom toolbars
            HStack(spacing: 8) {
                // Main toolbar (left)
                HStack(spacing: 20) {
                    Button { } label: {
                        composerIcon("icon-photo")
                    }
                    Button { } label: {
                        composerIcon("icon-camera")
                    }
                    Button { } label: {
                        composerIcon("icon-grok")
                    }
                    Button { } label: {
                        composerIcon("icon-live")
                    }
                    Button { } label: {
                        composerIcon("icon-bulleted list")
                    }
                    Button { } label: {
                        composerIcon("icon-sparkles")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 32))
                
                Spacer()
                
                // Small toolbar (right)
                HStack(spacing: 16) {
                    Button { } label: {
                        Image("icon-counter")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.label).opacity(0.3))
                    }
                    Button { } label: {
                        composerIcon("icon-plus-fill")
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 32))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .onAppear {
            isTextFieldFocused = true
        }
    }

    @ViewBuilder
    private func composerIcon(_ name: String) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(Color(.label))
    }
}


#Preview("Main Tab") {
    MainTabView()
}
