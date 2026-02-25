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
                NavigationStack { FeedView(isSidebarShowing: $isSidebarShowing) }
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
                .zIndex(2)
            
            // Settings screen - slides in from right
            if isSettingsShowing {
                SettingsView(isShowing: $isSettingsShowing, username: User.current.username)
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
            }
            
            // Premium screen - slides in from right
            if isPremiumShowing {
                PremiumView(isShowing: $isPremiumShowing, username: User.current.username)
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
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

#Preview {
    MainTabView()
}
