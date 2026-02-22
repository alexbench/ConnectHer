import SwiftUI

struct ConversationListView: View {
    @Bindable var viewModel: MessagesViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(Theme.primary)
                } else if viewModel.conversations.isEmpty {
                    emptyState
                } else {
                    conversationList
                }
            }
            .navigationTitle("Messages")
            .task {
                await viewModel.loadConversations()
            }
        }
    }

    private var conversationList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink {
                        ChatView(
                            viewModel: viewModel,
                            conversation: conversation
                        )
                    } label: {
                        ConversationRow(conversation: conversation)
                    }
                    .buttonStyle(.plain)

                    if conversation.id != viewModel.conversations.last?.id {
                        Divider()
                            .background(Theme.divider)
                            .padding(.leading, 76)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(Theme.horizontalPadding)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 56))
                .foregroundStyle(Theme.primary.opacity(0.4))

            Text("No conversations yet")
                .font(Theme.heading(22))
                .foregroundStyle(Theme.textPrimary)

            Text("When you connect with someone, start the conversation here. A great opener is asking about their experience or shared interests!")
                .font(Theme.body(15))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.primary, Theme.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .overlay {
                        Text(conversation.otherUser.firstName.prefix(1))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                if conversation.unreadCount > 0 {
                    Circle()
                        .fill(Theme.primary)
                        .frame(width: 18, height: 18)
                        .overlay {
                            Text("\(conversation.unreadCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 2, y: 2)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.otherUser.firstName)
                        .font(Theme.subheading(16))
                        .foregroundStyle(Theme.textPrimary)

                    Spacer()

                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.sentAt.relativeString)
                            .font(Theme.caption(12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage.text)
                        .font(Theme.body(14))
                        .foregroundStyle(conversation.unreadCount > 0 ? Theme.textPrimary : Theme.textSecondary)
                        .fontWeight(conversation.unreadCount > 0 ? .medium : .regular)
                        .lineLimit(2)
                } else {
                    Text("New connection! Say hello")
                        .font(Theme.body(14))
                        .foregroundStyle(Theme.primary)
                        .italic()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
