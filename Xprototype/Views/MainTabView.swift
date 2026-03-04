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
    @State private var isTopicSheetShowing = false
    @State private var pinnedTopics: [String] = []
    @State private var feedSelectedTab = 0
    
    // Sidebar width for content offset
    private var sidebarWidth: CGFloat {
    
        UIScreen.main.bounds.width * 0.78
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            // Main tab content
            TabView(selection: $selectedTab) {
                NavigationStack { FeedView(isSidebarShowing: $isSidebarShowing, isTopicSheetShowing: $isTopicSheetShowing, pinnedTopics: $pinnedTopics, selectedTab: $feedSelectedTab) }
                    .tabItem { tabIcon("icon-home", title: "", tag: 0) }
                    .tag(0)
                
                NavigationStack { ExploreView() }
                    .tabItem { tabIcon("icon-explore", title: "", tag: 1) }
                    .tag(1)
                
                NavigationStack { NotificationsView() }
                    .tabItem { tabIcon("icon-bell", title: "", tag: 2) }
                    .tag(2)
                
                NavigationStack { GrokView() }
                    .tabItem { tabIcon("icon-grok", title: "", tag: 3) }
                    .tag(3)
                
                NavigationStack { MessagesView() }
                    .tabItem { tabIcon("icon-message", title: "", tag: 4) }
                    .tag(4)
            }
            .tint(colorScheme == .dark ? .white : .black)
            .offset(x: isSidebarShowing ? sidebarWidth : 0)
            .animation(.easeOut(duration: 0.25), value: isSidebarShowing)
            .sheet(isPresented: $isTopicSheetShowing) {
                TopicSheetContent(pinnedTopics: $pinnedTopics, feedSelectedTab: $feedSelectedTab)
                    .presentationDetents([.fraction(0.7)])
            }
            .onAppear {
                // Configure tab bar appearance for proper dark mode support
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                UITabBar.appearance().tintColor = .label
            }
            
            // Sidebar overlay
            SidebarView(isShowing: $isSidebarShowing, isSettingsShowing: $isSettingsShowing, isPremiumShowing: $isPremiumShowing, user: .current)
            
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

#Preview {
    MainTabView()
}
