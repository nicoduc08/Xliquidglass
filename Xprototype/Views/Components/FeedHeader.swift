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
    
    var body: some View {
        HStack {
            // Profile glass button
            Button {
                onAvatarTap?()
            } label: {
                Image("Avatar 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            .buttonStyle(GlassButtonStyle())
            
            Spacer()
            
            // Tab buttons
            HStack(spacing: 8) {
                ForEach(Array(["For you", "Following"].enumerated()), id: \.offset) { index, title in
                    GlassTabButton(
                        title: title,
                        isSelected: selectedTab == index
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = index
                        }
                    }
                }
            }
            
            Spacer()
            
            // Notification glass button
            Button {
                // Handle notification tap
            } label: {
                Image("icon-bell-outline")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.label))
            }
            .buttonStyle(GlassButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaTop + 4)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(.systemBackground), location: 0),
                    .init(color: Color(.systemBackground), location: 0.6),
                    .init(color: Color(.systemBackground).opacity(0), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            // .padding(.bottom, -40)
            .ignoresSafeArea(edges: .top)
        )
        .allowsHitTesting(true)
    }
}

// MARK: - Glass Tab Button
struct GlassTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.chirpBold(size: 13))
                .foregroundColor(isSelected ? Color(.systemBackground) : Color(.label))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
        }
        .modify { view in
            if isSelected {
                view.buttonStyle(GlassProminentButtonStyle())
            } else {
                view.buttonStyle(GlassButtonStyle())
            }
        }
    }
}

// MARK: - Conditional Modifier
private extension View {
    @ViewBuilder
    func modify<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> T {
        modifier(self)
    }
}
