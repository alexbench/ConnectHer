import Foundation

struct Match: Codable, Identifiable {
    let id: String
    let userId1: String
    let userId2: String
    var status: MatchStatus
    var user1Liked: Bool
    var user2Liked: Bool
    var createdAt: Date
    var lastMessageAt: Date?

    /// The other user in the match, given the current user's ID.
    func otherUserId(currentUserId: String) -> String {
        currentUserId == userId1 ? userId2 : userId1
    }
}

enum MatchStatus: String, Codable {
    case pending
    case mutual
    case unmatched
}
