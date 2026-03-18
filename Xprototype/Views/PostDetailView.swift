//
//  PostDetailView.swift
//  Xprototype
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @Environment(\.dismiss) private var dismiss
    @State private var replyText = ""
    @FocusState private var isReplyFocused: Bool
    
    private var metaColor: Color { .secondaryText }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Anchor for scroll-to-top (expands tab bar)
                    Color.clear
                        .frame(height: 0)
                        .id("top")
                    
                    // Author row
                HStack(spacing: 10) {
                    Image(post.avatarName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(post.authorName)
                                .font(.chirpBold(size: 16))
                            if post.isVerified {
                                Image("icon-verified")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                        }
                        Text("@\(post.username)")
                            .font(.chirpRegular(size: 14))
                            .foregroundStyle(metaColor)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Follow action
                    } label: {
                        Text("Follow")
                            .font(.chirpBold(size: 14))
                            .foregroundStyle(Color(.systemBackground))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .background(Color(.label))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Post content
                Text(post.content)
                    .font(.chirpRegular(size: 17))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                // Post image
                if let imageName = post.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(.label).opacity(0.15), lineWidth: 0.5)
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }
                
                // Timestamp · Date · Views
                HStack(spacing: 0) {
                    Text(post.timestamp.formatted(date: .omitted, time: .shortened).lowercased())
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(metaColor)
                    Text(" · ")
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(metaColor)
                    Text(post.timestamp.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year(.twoDigits)))
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(metaColor)
                    Text(" · ")
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(metaColor)
                    Text(post.views, format: .number.notation(.compactName))
                        .font(.chirpBold(size: 14))
                    Text(" Views")
                        .font(.chirpRegular(size: 14))
                        .foregroundStyle(metaColor)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Action bar with counts
                HStack(spacing: 0) {
                    CustomActionButton(iconName: "icon-reply", count: post.replies, iconSize: 24, fontSize: 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                    CustomActionButton(iconName: "icon-repost", count: post.reposts, iconSize: 24, fontSize: 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                    CustomActionButton(iconName: "icon-like", count: post.likes, iconSize: 24, fontSize: 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                    CustomActionButton(iconName: "icon-bookmark", count: post.bookmarks, iconSize: 24, fontSize: 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Image("icon-share")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(metaColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                
                Divider()
                
                // Replies
                ForEach(PostDetailView.mockReplies) { reply in
                    PostCell(post: reply)
                    Rectangle()
                        .fill(Color(.label).opacity(0.15))
                        .frame(height: 0.5)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            isReplyFocused = false
        }
        .background(Color(.systemBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(.label))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Post")
                    .font(.chirpBold(size: 17))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // More options
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color(.label))
                }
            }
        }
        .tabBarMinimizeBehavior(.never)
        } // ScrollViewReader
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                if isReplyFocused {
                    // Replying to
                    HStack(spacing: 4) {
                        Text("Replying to")
                            .font(.chirpRegular(size: 14))
                            .foregroundStyle(.secondary)
                        Text("@\(post.username)")
                            .font(.chirpRegular(size: 14))
                            .foregroundStyle(Color(.label))
                    }
                    .padding(.bottom, 10)
                }
                
                // Avatar + text input
                HStack(alignment: .center, spacing: 10) {
                    Image("Avatar 1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    
                    TextField("", text: $replyText, prompt: Text("Post your reply").foregroundStyle(Color.secondaryText))
                        .font(.chirpRegular(size: isReplyFocused ? 16 : 15))
                        .focused($isReplyFocused)
                }
                
                if isReplyFocused {
                    // Media icons + Reply button
                    HStack {
                        HStack(spacing: 24) {
                            replyIcon("icon-photo")
                            replyIcon("icon-camera")
                            replyIcon("icon-grok")
                            replyIcon("icon-live")
                            replyIcon("icon-gif")
                        }
                        
                        Spacer()
                        
                        Button {
                            replyText = ""
                            isReplyFocused = false
                        } label: {
                            Text("Reply")
                                .font(.chirpBold(size: 15))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(replyText.isEmpty ? Color(.label).opacity(0.3) : Color(.label))
                                )
                        }
                        .disabled(replyText.isEmpty)
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, isReplyFocused ? 14 : 10)
            .contentShape(Rectangle())
            .onTapGesture {
                isReplyFocused = true
            }
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: isReplyFocused ? 24 : 50))
            .padding(.horizontal, isReplyFocused ? 16 : 24)
            .padding(.bottom, isReplyFocused ? 8 : 12)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isReplyFocused)
        }
    }
    
    @ViewBuilder
    private func replyIcon(_ name: String) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 22, height: 22)
            .foregroundStyle(Color(.label))
    }
    
    // MARK: - Mock Replies
    private static let mockReplies: [Post] = [
        Post(
            authorName: "David Kim",
            username: "davidk",
            content: "This is so true! Couldn't agree more 🙌",
            timestamp: Date().addingTimeInterval(-1800),
            isVerified: false,
            avatarName: "Avatar 10",
            imageName: nil,
            replies: 2, reposts: 0, likes: 14, views: 320, bookmarks: 1
        ),
        Post(
            authorName: "Emma Wilson",
            username: "emmawilson",
            content: "Great perspective. I've been thinking about this a lot lately and you've put it into words perfectly.",
            timestamp: Date().addingTimeInterval(-2400),
            isVerified: true,
            avatarName: "Avatar 15",
            imageName: nil,
            replies: 1, reposts: 3, likes: 42, views: 890, bookmarks: 5
        ),
        Post(
            authorName: "Marcus J.",
            username: "marcusj_dev",
            content: "100% this. Sharing with my team right now.",
            timestamp: Date().addingTimeInterval(-3200),
            isVerified: false,
            avatarName: "Avatar 8",
            imageName: nil,
            replies: 0, reposts: 1, likes: 8, views: 150, bookmarks: 0
        ),
        Post(
            authorName: "Lina Torres",
            username: "linatorres",
            content: "Needed to hear this today. Thanks for sharing 💯",
            timestamp: Date().addingTimeInterval(-4500),
            isVerified: false,
            avatarName: "Avatar 16",
            imageName: nil,
            replies: 3, reposts: 0, likes: 27, views: 510, bookmarks: 2
        ),
        Post(
            authorName: "Ryan Patel",
            username: "ryanp",
            content: "This hit different. Bookmarked for future reference.",
            timestamp: Date().addingTimeInterval(-5400),
            isVerified: true,
            avatarName: "Avatar 11",
            imageName: nil,
            replies: 1, reposts: 2, likes: 19, views: 430, bookmarks: 8
        )
    ]
}

#Preview {
    NavigationStack {
        PostDetailView(post: Post.mock[0])
    }
}