import Foundation

@Observable
@MainActor
final class MessagesViewModel {
    var conversations: [Conversation] = []
    var currentMessages: [Message] = []
    var isLoading = false
    var messageText = ""

    func loadConversations() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        conversations = MockData.conversations
        isLoading = false
    }

    func loadMessages(for matchId: String) async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 300_000_000)

        switch matchId {
        case "match-1":
            currentMessages = MockData.messagesForMatch1
        case "match-2":
            currentMessages = MockData.messagesForMatch2
        default:
            currentMessages = []
        }

        isLoading = false
    }

    func sendMessage(matchId: String, senderId: String) {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let message = Message(
            id: UUID().uuidString,
            matchId: matchId,
            senderId: senderId,
            text: messageText,
            sentAt: Date(),
            isRead: false
        )

        currentMessages.append(message)

        // Update last message in conversations list
        if let index = conversations.firstIndex(where: { $0.id == matchId }) {
            conversations[index] = Conversation(
                id: conversations[index].id,
                match: conversations[index].match,
                otherUser: conversations[index].otherUser,
                lastMessage: message,
                unreadCount: conversations[index].unreadCount
            )
        }

        messageText = ""
    }

    var totalUnread: Int {
        conversations.reduce(0) { $0 + $1.unreadCount }
    }
}
