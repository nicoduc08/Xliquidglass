//
//  User.swift
//  Xprototype
//

import Foundation

struct User {
    let displayName: String
    let username: String
    let avatarName: String
    let isVerified: Bool
    let followersCount: Int
    let followingCount: Int
    
    var formattedFollowers: String {
        formatCount(followersCount)
    }
    
    var formattedFollowing: String {
        formatCount(followingCount)
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fM", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return String(format: "%.1fK", Double(count) / 1_000)
        }
        return "\(count)"
    }
}

extension User {
    static let current = User(
        displayName: "Nico",
        username: "nicoduc",
        avatarName: "Avatar 1",
        isVerified: true,
        followersCount: 1234,
        followingCount: 567
    )
}
