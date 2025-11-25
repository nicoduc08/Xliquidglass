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
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { FeedView() }
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
        .onAppear {
            // Configure tab bar appearance for proper dark mode support
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
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
