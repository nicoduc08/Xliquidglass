//
//  FeedView.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

// FeedView.swift
import SwiftUI

struct FeedView: View {
    @Binding var isSidebarShowing: Bool
    @Binding var isInDetailView: Bool
    @Namespace private var postTransition
    @State private var navigationPath = NavigationPath()

    private let posts = Post.mock

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(posts) { post in
                        Button {
                            navigationPath.append(post)
                        } label: {
                            PostCell(post: post)
                                .matchedTransitionSource(id: post.id, in: postTransition) { source in
                                    source
                                        .background(Color(.systemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 0))
                                        .shadow(color: .clear, radius: 0)
                                }
                        }
                        .buttonStyle(.plain)
                        Rectangle()
                            .fill(Color(.label).opacity(0.10))
                            .frame(height: 0.5)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.easeOut(duration: 0.25)) {
                            isSidebarShowing = true
                        }
                    } label: {
                        Image("Avatar 1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .principal) {
                    Image("icon-x")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(.label))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Grok button tapped")
                    } label: {
                        Image("icon-grok")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.label))
                    }
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        // Only respond to swipes starting near the left edge
                        guard value.startLocation.x < 40 else { return }
                        if value.translation.width > 80 || value.predictedEndTranslation.width > 150 {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isSidebarShowing = true
                            }
                        }
                    }
            )
            .navigationDestination(for: Post.self) { post in
                PostDetailView(post: post)
                    .navigationTransition(.zoom(sourceID: post.id, in: postTransition))
            }
        }
        .onChange(of: navigationPath.count) { _, newCount in
            isInDetailView = newCount > 0
        }
    }
}

// MARK: - Removed SelectedRowAnchorKey
// This was used for the complex tooltip system that was removed

// MARK: - Removed TopicBottomSheet
// This was the old complex sheet implementation that was replaced with TopicSheetContent

#Preview {
    FeedView(isSidebarShowing: .constant(false), isInDetailView: .constant(false))
}
