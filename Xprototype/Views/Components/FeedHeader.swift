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
    
    var body: some View {
        VStack(spacing: 0) {
            // Actual header content
            HStack(spacing: 0) {
                TabButton(title: "For you", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabButton(title: "Following", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabButton(title: "Seen", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal)
            .frame(height: 44)
            
            Divider()
        }
        .padding(.top, safeAreaTop)
        .background(.ultraThinMaterial)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.chirpRegular(size: 15))
                    .foregroundStyle(isSelected ? .primary : Color.secondaryText)
                
                if isSelected {
                    Rectangle()
                        .fill(Color.primary)
                        .frame(height: 2)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

