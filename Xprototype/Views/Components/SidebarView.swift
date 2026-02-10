//
//  SidebarView.swift
//  Xprototype
//

import SwiftUI

struct SidebarView: View {
    @Binding var isShowing: Bool
    @Binding var isSettingsShowing: Bool
    let user: User
    
    private let sidebarWidth: CGFloat = UIScreen.main.bounds.width * 0.78
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Dimmed background overlay
            if isShowing {
                Color(red: 0.737, green: 0.769, blue: 0.788)
                    .opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.1)) {
                            isShowing = false
                        }
                    }
            }
            
            // Sidebar content
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header section
                    SidebarHeader(user: user)
                    
                    // Menu items
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            SidebarMenuItem(icon: "icon-sidebar-profile", title: "Profile")
                            SidebarMenuItem(icon: "icon-sidebar-premium", title: "Premium+")
                            SidebarMenuItem(icon: "icon-sidebar-money", title: "Money")
                            SidebarMenuItem(icon: "icon-sidebar-video", title: "Video")
                            SidebarMenuItem(icon: "icon-sidebar-communities", title: "Communities")
                            SidebarMenuItem(icon: "icon-sidebar-bookmark", title: "Bookmarks")
                            SidebarMenuItem(icon: "icon-sidebar-lists", title: "Lists")
                            SidebarMenuItem(icon: "icon-sidebar-spaces", title: "Spaces")
                            SidebarMenuItem(icon: "icon-sidebar-studio", title: "Creator Studio")
                            SidebarMenuItem(icon: "icon-sidebar-conferences", title: "Conferences")
                            
                            Divider()
                                .padding(.vertical, 12)
                            
                            SidebarMenuItem(icon: "icon-sidebar-grok", title: "Open Grok", titleFont: .chirpMedium(size: 15))
                            SidebarMenuItem(icon: "icon-sidebar-settings", title: "Settings and privacy", titleFont: .chirpMedium(size: 15)) {
                                // Close sidebar and open settings simultaneously
                                withAnimation(.easeOut(duration: 0.25)) {
                                    isShowing = false
                                    isSettingsShowing = true
                                }
                            }
                            SidebarMenuItem(icon: "icon-sidebar-help", title: "Help Center", titleFont: .chirpMedium(size: 15))
                        }
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    // Footer with theme toggle
                    HStack {
                        Image(systemName: "sun.max")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.secondaryText)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .frame(width: sidebarWidth)
                .background(Color(.systemBackground))
                
                Spacer()
            }
            .offset(x: isShowing ? 0 : -sidebarWidth)
            .animation(.easeOut(duration: 0.25), value: isShowing)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        withAnimation(.easeOut(duration: 0.1)) {
                            isShowing = false
                        }
                    }
                }
        )
    }
}

// MARK: - Sidebar Header
struct SidebarHeader: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Large avatar
            Image(user.avatarName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            // Display name with verification badge
            HStack(spacing: 4) {
                Text(user.displayName)
                    .font(.chirpBold(size: 18))
                    .foregroundStyle(Color(.label))
                
                if user.isVerified {
                    Image("icon-verified")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.top, 8)
            
            // Username
            Text("@\(user.username)")
                .font(.chirpRegular(size: 15))
                .foregroundStyle(Color.secondaryText)
            
            // Follower/Following counts
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Text(user.formattedFollowing)
                        .font(.chirpBold(size: 14))
                        .foregroundStyle(Color(.label))
                    Text("Following")
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(Color.secondaryText)
                }
                
                HStack(spacing: 4) {
                    Text(user.formattedFollowers)
                        .font(.chirpBold(size: 14))
                        .foregroundStyle(Color(.label))
                    Text("Followers")
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(Color.secondaryText)
                }
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - Sidebar Menu Item
struct SidebarMenuItem: View {
    let icon: String
    let title: String
    var titleFont: Font = .chirpBold(size: 20)
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.label))
                    .frame(width: 28)
                
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(Color(.label))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SidebarView(isShowing: .constant(true), isSettingsShowing: .constant(false), user: .current)
}
