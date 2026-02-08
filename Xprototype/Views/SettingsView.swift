//
//  SettingsView.swift
//  Xprototype
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowing: Bool
    let username: String
    @Environment(\.colorScheme) private var colorScheme
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    // Get actual device safe area from window
    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : Color(.systemBackground)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(.label)
    }
    
    private var searchBarBackground: Color {
        colorScheme == .dark ? Color(hex: "#202327") : Color(.systemGray6)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isShowing = false
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(textColor)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("Settings")
                            .font(.chirpHeavy(size: 17))
                            .foregroundStyle(textColor)
                        
                        Text("@\(username)")
                            .font(.chirpRegular(size: 13))
                            .foregroundStyle(Color.secondaryText)
                    }
                    
                    Spacer()
                    
                    // Invisible spacer to balance the back button
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.clear)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .padding(.top, safeAreaTop)
            .padding(.bottom, 16)
            
            // Search bar
            HStack {
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.secondaryText)
                    
                    Text("Search settings")
                        .font(.chirpRegular(size: 16))
                        .foregroundStyle(Color.secondaryText)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .background(searchBarBackground)
            .cornerRadius(20)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .drawingGroup()
            
            // Menu items
            ScrollView {
                VStack(spacing: 0) {
                    SettingsMenuItem(icon: "person", title: "Your account")
                    SettingsMenuItem(icon: "lock.shield", title: "Security and account access")
                    SettingsMenuItem(icon: "star", title: "Premium")
                    SettingsMenuItem(icon: "list.bullet.rectangle", title: "Timeline")
                    SettingsMenuItem(icon: "hand.raised", title: "Privacy and safety")
                    SettingsMenuItem(icon: "bell", title: "Notifications")
                    SettingsMenuItem(icon: "textformat.size", title: "Accessibility, display, and languages")
                    SettingsMenuItem(icon: "ellipsis.circle", title: "Additional resources")
                }
            }
            
            Spacer()
        }
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.top])
        .offset(x: dragOffset)
        .animation(isDragging ? nil : .easeOut(duration: 0.25), value: dragOffset)
        .simultaneousGesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    // Only respond to swipes starting near the left edge
                    guard value.startLocation.x < 40 else { return }
                    if value.translation.width > 0 {
                        state = value.translation.width
                    }
                }
                .onChanged { value in
                    if value.startLocation.x < 40 {
                        isDragging = true
                    }
                }
                .onEnded { value in
                    guard value.startLocation.x < 40 else { return }
                    isDragging = false
                    let screenWidth = UIScreen.main.bounds.width
                    // Dismiss if dragged past 35% of screen or flicked fast enough
                    if value.translation.width > screenWidth * 0.35 || value.predictedEndTranslation.width > screenWidth * 0.5 {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isShowing = false
                        }
                    }
                }
        )
    }
}

// MARK: - Settings Menu Item
struct SettingsMenuItem: View {
    let icon: String
    let title: String
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(.label)
    }
    
    var body: some View {
        Button(action: {
            // Handle menu item tap
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(textColor)
                    .frame(width: 28)
                
                Text(title)
                    .font(.chirpBold(size: 15))
                    .foregroundStyle(textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.secondaryText)
            }
            .padding(.leading, 16)
            .padding(.trailing, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView(isShowing: .constant(true), username: "nicoduc")
}
