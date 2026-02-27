//
//  Post.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let authorName: String
    let username: String
    let content: String
    let timestamp: Date
    let isVerified: Bool
    let avatarName: String
    let imageName: String?
    
    let replies: Int
    let reposts: Int
    let likes: Int
    let views: Int
    let bookmarks: Int
    
    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        let hours = Int(interval / 3600)
        let minutes = Int(interval / 60)
        
        if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "now"
        }
    }
}

extension Post {
    static let mock: [Post] = [
        Post(
            authorName: "Brian Lee",
            username: "brian8lee",
            content: "A good laugh and a long, rejuvenating sleep are two of the most potent remedies for a wide array of ailments...",
            timestamp: Date().addingTimeInterval(-3*3600),
            isVerified: true,
            avatarName: "Avatar 12",
            imageName: nil,
            replies: 732, reposts: 454, likes: 1200, views: 10000, bookmarks: 89
        ),
        Post(
            authorName: "StripMallGuy",
            username: "realEstateTrent",
            content: """
            I miss San Francisco.
            
            I miss Crissy Field. The Marina Green.
            
            I miss that walk along the water at sunset...
            """,
            timestamp: Date().addingTimeInterval(-3600),
            isVerified: true,
            avatarName: "Avatar 2",
            imageName: nil,
            replies: 89, reposts: 210, likes: 1800, views: 45000, bookmarks: 312
        ),
        Post(
            authorName: "Sarah Chen",
            username: "sarahcodes",
            content: "Just shipped a new feature that I've been working on for weeks. The feeling of seeing it live is unmatched. 🚀",
            timestamp: Date().addingTimeInterval(-2*3600),
            isVerified: false,
            avatarName: "Avatar 3",
            imageName: "LA",
            replies: 45, reposts: 12, likes: 234, views: 3200, bookmarks: 18
        ),
        Post(
            authorName: "Tech News",
            username: "technews",
            content: "Breaking: Major tech company announces revolutionary AI breakthrough that could change everything we know about machine learning.",
            timestamp: Date().addingTimeInterval(-4*3600),
            isVerified: true,
            avatarName: "Avatar 4",
            imageName: nil,
            replies: 1200, reposts: 890, likes: 5600, views: 125000, bookmarks: 1450
        ),
        Post(
            authorName: "Alex Rivera",
            username: "alexdesigns",
            content: "Design is not just what it looks like and feels like. Design is how it works.",
            timestamp: Date().addingTimeInterval(-5*3600),
            isVerified: false,
            avatarName: "Avatar 5",
            imageName: nil,
            replies: 23, reposts: 8, likes: 156, views: 2100, bookmarks: 34
        ),
        Post(
            authorName: "Coffee Lover",
            username: "coffeeaddict",
            content: "There's nothing quite like that first sip of coffee in the morning. It's like a warm hug for your soul. ☕",
            timestamp: Date().addingTimeInterval(-6*3600),
            isVerified: false,
            avatarName: "Avatar 6",
            imageName: "rocket",
            replies: 67, reposts: 34, likes: 412, views: 5800, bookmarks: 56
        ),
        Post(
            authorName: "Maya Patel",
            username: "mayawrites",
            content: "Writing is thinking on paper. Sometimes the words flow, sometimes they don't. But the process is always worth it.",
            timestamp: Date().addingTimeInterval(-7*3600),
            isVerified: false,
            avatarName: "Avatar 7",
            imageName: nil,
            replies: 12, reposts: 5, likes: 89, views: 1500, bookmarks: 11
        ),
        Post(
            authorName: "Startup Founder",
            username: "startuplife",
            content: "Building a startup is 1% inspiration and 99% perspiration. But that 1% makes all the difference.",
            timestamp: Date().addingTimeInterval(-8*3600),
            isVerified: true,
            avatarName: "Avatar 8",
            imageName: nil,
            replies: 234, reposts: 156, likes: 890, views: 12000, bookmarks: 178
        ),
        Post(
            authorName: "Nature Photographer",
            username: "naturelens",
            content: "Captured this stunning sunset yesterday. Sometimes nature reminds us why we're here. 🌅",
            timestamp: Date().addingTimeInterval(-9*3600),
            isVerified: false,
            avatarName: "Avatar 9",
            imageName: "book",
            replies: 89, reposts: 45, likes: 567, views: 8900, bookmarks: 93
        ),
        Post(
            authorName: "Bookworm",
            username: "readmorebooks",
            content: "Just finished reading an incredible novel. The power of storytelling never ceases to amaze me. What are you reading?",
            timestamp: Date().addingTimeInterval(-10*3600),
            isVerified: false,
            avatarName: "Avatar 10",
            imageName: nil,
            replies: 156, reposts: 23, likes: 345, views: 4500, bookmarks: 67
        ),
        Post(
            authorName: "Fitness Coach",
            username: "fitlife",
            content: "Remember: progress, not perfection. Every small step counts. You've got this! 💪",
            timestamp: Date().addingTimeInterval(-11*3600),
            isVerified: true,
            avatarName: "Avatar 11",
            imageName: nil,
            replies: 78, reposts: 67, likes: 456, views: 6700, bookmarks: 42
        ),
        Post(
            authorName: "Music Producer",
            username: "soundmaker",
            content: "New track dropping next week. Can't wait to share what I've been working on. The energy is different this time.",
            timestamp: Date().addingTimeInterval(-12*3600),
            isVerified: false,
            avatarName: "Avatar 12",
            imageName: "steve",
            replies: 234, reposts: 189, likes: 1234, views: 15600, bookmarks: 205
        ),
        Post(
            authorName: "Travel Blogger",
            username: "wanderlust",
            content: "Just landed in a new city. The adventure begins! There's something magical about exploring places you've never been.",
            timestamp: Date().addingTimeInterval(-13*3600),
            isVerified: true,
            avatarName: "Avatar 13",
            imageName: nil,
            replies: 345, reposts: 234, likes: 1789, views: 23400, bookmarks: 456
        )
    ]
}
