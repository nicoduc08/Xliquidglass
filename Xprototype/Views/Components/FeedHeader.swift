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
    var onAvatarTap: (() -> Void)? = nil
    @Namespace private var underlineNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            // Avatar row (above tabs)
            HStack {
                Image("Avatar 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .onTapGesture {
                        onAvatarTap?()
                    }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 6)
            
            // Tabs
            HStack(spacing: 0) {
                TabButton(title: "For you", id: 0, isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabButton(title: "Following", id: 1, isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabButton(title: "Seen", id: 2, isSelected: selectedTab == 2) {
                    selectedTab = 2
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
        .background(.ultraThinMaterial)
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
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.chirpBold(size: 15))
                    .foregroundStyle(isSelected ? selectedColor : Color.secondaryText)
                    .fixedSize()
                    .anchorPreference(key: TabTextBoundsKey.self, value: .bounds) { anchor in
                        [id: anchor]
                    }
                
                Color.clear
                    .frame(height: 2)
            }
            .frame(maxWidth: .infinity)
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
