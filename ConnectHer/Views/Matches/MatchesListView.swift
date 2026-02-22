import SwiftUI

struct MatchesListView: View {
    @Bindable var viewModel: MatchesViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(Theme.primary)
                } else if viewModel.matches.isEmpty {
                    emptyState
                } else {
                    matchesList
                }
            }
            .navigationTitle("Connections")
            .task {
                await viewModel.loadMatches()
            }
        }
    }

    private var matchesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.matches) { match in
                    if let profile = viewModel.profileFor(match: match) {
                        MatchRow(profile: profile, match: match)
                    }
                }
            }
            .padding(Theme.horizontalPadding)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            CoffeeMugIcon(size: 56)
                .opacity(0.4)

            Text("No connections yet")
                .font(Theme.heading(22))
                .foregroundStyle(Theme.textPrimary)

            Text("Start swiping to find professional women to connect with in your area.")
                .font(Theme.body(15))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

struct MatchRow: View {
    let profile: UserProfile
    let match: Match

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Theme.primary, Theme.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .overlay {
                    Text(profile.firstName.prefix(1))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.firstName)
                    .font(Theme.subheading(16))
                    .foregroundStyle(Theme.textPrimary)

                Text(profile.headline)
                    .font(Theme.caption(13))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)

                Text("Connected \(match.createdAt.relativeString)")
                    .font(Theme.caption(11))
                    .foregroundStyle(Theme.textSecondary.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary.opacity(0.5))
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

// MARK: - Date Extension

extension Date {
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
