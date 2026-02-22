import SwiftUI

struct ChatView: View {
    @Bindable var viewModel: MessagesViewModel
    let conversation: Conversation
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        // Conversation header
                        conversationHeader
                            .padding(.bottom, 12)

                        ForEach(viewModel.currentMessages) { message in
                            MessageBubbleView(
                                message: message,
                                isCurrentUser: message.senderId == MockData.currentUser.id
                            )
                            .id(message.id)
                        }
                    }
                    .padding(Theme.horizontalPadding)
                }
                .onChange(of: viewModel.currentMessages.count) {
                    if let lastId = viewModel.currentMessages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider().background(Theme.divider)

            // Message input
            messageInput
        }
        .background(Theme.background)
        .navigationTitle(conversation.otherUser.firstName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMessages(for: conversation.id)
        }
    }

    private var conversationHeader: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Theme.primary, Theme.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 64, height: 64)
                .overlay {
                    Text(conversation.otherUser.firstName.prefix(1))
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            Text(conversation.otherUser.fullName)
                .font(Theme.subheading(16))
                .foregroundStyle(Theme.textPrimary)

            Text(conversation.otherUser.headline)
                .font(Theme.caption(13))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            Text("You connected \(conversation.match.createdAt.relativeString)")
                .font(Theme.caption(12))
                .foregroundStyle(Theme.textSecondary.opacity(0.7))
        }
        .padding(.top, 20)
    }

    private var messageInput: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $viewModel.messageText, axis: .vertical)
                .font(Theme.body(15))
                .lineLimit(1...5)
                .focused($isInputFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())

            Button {
                viewModel.sendMessage(
                    matchId: conversation.id,
                    senderId: MockData.currentUser.id
                )
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? Theme.textSecondary.opacity(0.3)
                            : Theme.primary
                    )
            }
            .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

struct MessageBubbleView: View {
    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser { Spacer(minLength: 60) }

            Text(message.text)
                .font(Theme.body(15))
                .foregroundStyle(isCurrentUser ? .white : Theme.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isCurrentUser ? Theme.primary : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.04), radius: 2, y: 1)

            if !isCurrentUser { Spacer(minLength: 60) }
        }
    }
}
