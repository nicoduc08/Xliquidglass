//
//  FeedHeader.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct FeedHeader: View {
    let safeAreaTop: CGFloat
    var onAvatarTap: (() -> Void)? = nil
    var onGrokTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // iOS 26 Stock Header
            HStack(alignment: .center) {
                Button {
                    onAvatarTap?()
                } label: {
                    Image("Avatar 1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }

                Spacer()

                Button {
                    onGrokTap?()
                } label: {
                    Image("icon-grok")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color(.label))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .frame(height: 44)

            Divider()
        }
        .padding(.top, safeAreaTop)
        .background(Color(.systemBackground))
    }
}
