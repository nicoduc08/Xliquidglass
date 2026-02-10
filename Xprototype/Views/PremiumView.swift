//
//  PremiumView.swift
//  Xprototype
//

import SwiftUI

struct PremiumView: View {
    @Binding var isShowing: Bool
    let username: String
    @Environment(\.colorScheme) private var colorScheme
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
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
    
    private var sectionColor: Color {
        colorScheme == .dark ? .white : Color(.label)
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
                        Text("Premium")
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
            
            // Sections
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Section 1: Quick access
                    PremiumSectionHeader(title: "Quick access")
                    
                    PremiumMenuItem(icon: "sparkles", title: "SuperGrok")
                    PremiumMenuItem(icon: "eye.slash", title: "Ads avoided")
                    PremiumMenuItem(icon: "dot.radiowaves.left.and.right", title: "Radar")
                    PremiumMenuItem(icon: "wand.and.stars", title: "Creator Studio")
                    PremiumMenuItem(icon: "chart.bar", title: "Analytics")
                    PremiumMenuItem(icon: "arrow.down.circle", title: "Offline videos")
                    PremiumMenuItem(icon: "folder", title: "Bookmark Folders")
                    
                    // Section 2: Customization
                    PremiumSectionHeader(title: "Customization")
                    
                    PremiumMenuItem(icon: "at", title: "Request an inactive handle")
                    PremiumMenuItem(icon: "person.crop.square", title: "Profile customization")
                    PremiumMenuItem(icon: "text.alignleft", title: "Expanded Bio")
                    PremiumMenuItem(icon: "square.grid.2x2", title: "Customize navigation")
                    PremiumMenuItem(icon: "app.badge", title: "App icons")
                    PremiumMenuItem(icon: "paintbrush", title: "Theme")
                    
                    // Section 3: Verification & Security
                    PremiumSectionHeader(title: "Verification & Security")
                    
                    PremiumMenuItem(icon: "checkmark.shield", title: "ID Verification")
                    
                    // Section 4: Support
                    PremiumSectionHeader(title: "Support")
                    
                    PremiumMenuItem(icon: "questionmark.circle", title: "Help Center")
                    PremiumMenuItem(icon: "envelope", title: "Message @premium for support")
                    PremiumMenuItem(icon: "creditcard", title: "Manage your subscription")
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
                    if value.translation.width > screenWidth * 0.35 || value.predictedEndTranslation.width > screenWidth * 0.5 {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isShowing = false
                        }
                    }
                }
        )
    }
}

// MARK: - Section Header
struct PremiumSectionHeader: View {
    let title: String
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(.label)
    }
    
    var body: some View {
        Text(title)
            .font(.chirpHeavy(size: 20))
            .foregroundStyle(textColor)
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }
}

// MARK: - Premium Menu Item
struct PremiumMenuItem: View {
    let icon: String
    let title: String
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(.label)
    }
    
    private var chevronColor: Color {
        colorScheme == .dark ? Color(hex: "#595D62") : Color(hex: "#829AAB")
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
                    .font(.chirpMedium(size: 15))
                    .foregroundStyle(textColor)
                
                Spacer()
                
                Image("icon-chevron")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(chevronColor)
            }
            .padding(.leading, 16)
            .padding(.trailing, 20)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PremiumView(isShowing: .constant(true), username: "nicoduc")
}