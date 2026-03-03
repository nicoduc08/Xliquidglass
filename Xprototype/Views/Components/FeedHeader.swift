//
//  FeedHeader.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct FeedHeader: View {
    @Binding var selectedTab: Int
    let safeAreaTop: CGFloat
    @Binding var pinnedTopics: [String]
    var onAvatarTap: (() -> Void)? = nil
    var onBellTap: (() -> Void)? = nil
    @Namespace private var underlineNamespace
    
    // Build tab list: "For you" + pinned topics + "Following" + "Seen"
    private var tabs: [(id: Int, title: String)] {
        var result: [(id: Int, title: String)] = [(0, "For you")]
        result.append((1, "Following"))
        for (i, topic) in pinnedTopics.enumerated() {
            result.append((100 + i, topic))
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Avatar row
            HStack(alignment: .center) {
                Image("Avatar 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .onTapGesture {
                        onAvatarTap?()
                    }
                Spacer()
                Image("icon-x")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundStyle(Color(.label))
                Spacer()
                Button {
                    onBellTap?()
                } label: {
                    Image("icon-filter")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color(.label))
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 6)
            
            // Tabs
            Group {
                if pinnedTopics.isEmpty {
                    HStack(spacing: 16) {
                        ForEach(tabs, id: \.id) { tab in
                            TabButton(title: tab.title, id: tab.id, isSelected: selectedTab == tab.id) {
                                handleTabTap(tab)
                            }
                        }
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tabs, id: \.id) { tab in
                                TabButton(title: tab.title, id: tab.id, isSelected: selectedTab == tab.id) {
                                    handleTabTap(tab)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 40)
            .overlayPreferenceValue(TabTextBoundsKey.self) { preferences in
                GeometryReader { proxy in
                    if let anchor = preferences[selectedTab] {
                        let rect = proxy[anchor]
                        Rectangle()
                            .fill(Color.selectedTab)
                            .frame(width: rect.width, height: 3)
                            .cornerRadius(1.5)
                            .position(x: rect.midX, y: rect.maxY + 12)
                            .animation(.easeInOut(duration: 0.25), value: selectedTab)
                    }
                }
            }
            
            Divider()
        }
        .padding(.top, safeAreaTop)
        .background(Color(.systemBackground))
    }
    
    private func handleTabTap(_ tab: (id: Int, title: String)) {
        // If tapping an already-selected pinned tab, remove it
        if tab.id >= 100 && selectedTab == tab.id {
            let index = tab.id - 100
            if index < pinnedTopics.count {
                withAnimation(.easeInOut(duration: 0.25)) {
                    pinnedTopics.remove(at: index)
                    selectedTab = 0 // Go back to "For you"
                }
            }
        } else {
            selectedTab = tab.id
        }
    }
}

struct TabButton: View {
    let title: String
    let id: Int
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    private var selectedColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var unselectedColor: Color {
        colorScheme == .dark ? Color(hex: "#71767B") : Color(hex: "#536471")
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.chirpBold(size: 15))
                    .foregroundStyle(isSelected ? selectedColor : unselectedColor)
                    .fixedSize()
                    .anchorPreference(key: TabTextBoundsKey.self, value: .bounds) { anchor in
                        [id: anchor]
                    }
                
                Color.clear
                    .frame(height: 2)
            }
            .frame(minWidth: 80)
        }
        .background(Color.clear)
        .buttonStyle(.plain)
    }
}

private struct TabTextBoundsKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGRect>] = [:]
    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
