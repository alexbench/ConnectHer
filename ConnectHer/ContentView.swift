import SwiftUI

struct MainTabView: View {
    @Bindable var authVM: AuthViewModel
    @State private var discoverVM = DiscoverViewModel()
    @State private var matchesVM = MatchesViewModel()
    @State private var messagesVM = MessagesViewModel()
    @State private var profileVM = ProfileViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView(viewModel: discoverVM)
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }
                .tag(0)

            MatchesListView(viewModel: matchesVM)
                .tabItem {
                    Label("Connections", systemImage: "cup.and.saucer.fill")
                }
                .tag(1)

            ConversationListView(viewModel: messagesVM)
                .tabItem {
                    Label("Messages", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .badge(messagesVM.totalUnread)
                .tag(2)

            ProfileView(profileVM: profileVM) {
                authVM.signOut()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(3)
        }
        .tint(Theme.primary)
    }
}
