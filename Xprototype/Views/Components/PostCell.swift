//
//  PostCell.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

struct CustomActionButton: View {
    let iconName: String
    let count: Int
    
    private var iconColor: Color { .secondaryText }
    
    var body: some View {
        HStack(spacing: 5) {
            Image(iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 19, height: 19)
                .foregroundStyle(iconColor)
            
            if count > 0 {
                Text(count, format: .number.notation(.compactName))
                    .font(.chirpRegular(size: 13))
                    .foregroundStyle(iconColor)
            }
        }
    }
}

struct PostCell: View {
    let post: Post
    
    private var metaColor: Color { .secondaryText }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 10) {
                Image(post.avatarName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 4) {
                        Text(post.authorName)
                            .font(.chirpBold(size: 15))
                            .lineLimit(1)
                        if post.isVerified {
                            Image("icon-verified")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.blue)
                        }
                        HStack(spacing: 2) {
                            Text("@\(post.username)")
                                .foregroundStyle(metaColor)
                                .font(.chirpRegular(size: 15))
                                .lineLimit(1)
                            Text("∙")
                                .foregroundStyle(metaColor)
                                .font(.chirpRegular(size: 15))
                            Text(post.timeAgo)
                                .font(.chirpRegular(size: 13))
                                .foregroundStyle(metaColor)
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.ellipsisIcon)
            }
            
            // Content
            Text(post.content)
                .font(.chirpRegular(size: 15))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 54)
                .padding(.top, -24)
            
            // Action bar – no interaction, no isLiked needed
            HStack(spacing: 10) {
                CustomActionButton(iconName: "icon-reply", count: post.replies)
                CustomActionButton(iconName: "icon-repost", count: post.reposts)
                CustomActionButton(iconName: "icon-like", count: post.likes)                 
                CustomActionButton(iconName: "icon-views", count: post.views)
                Spacer()
                Image("icon-bookmark")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19, height: 19)
                    .foregroundStyle(metaColor)
                Image("icon-share")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19, height: 19)
                    .foregroundStyle(metaColor)
            }
            .font(.chirpRegular(size: 13))
            .padding(.leading, 54)
            .padding(.top, 16)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct ActionButton: View {
    let icon: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            if count > 0 {
                Text(count, format: .number.notation(.compactName))
                    .font(.caption)
            }
        }
    }
}


#Preview {
    PostCell(post: Post.mock[0])
        .padding()
}
