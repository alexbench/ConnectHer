import Foundation

struct Message: Codable, Identifiable {
    let id: String
    let matchId: String
    let senderId: String
    let text: String
    let sentAt: Date
    var isRead: Bool
}

struct Conversation: Identifiable {
    let id: String // same as matchId
    let match: Match
    let otherUser: UserProfile
    var lastMessage: Message?
    var unreadCount: Int
}
