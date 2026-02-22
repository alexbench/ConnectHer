import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        loadingView
                    } else if !viewModel.hasProfiles {
                        emptyStateView
                    } else {
                        cardStack
                        actionButtons
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        CoffeeMugIcon(size: 20)
                        Text(Constants.appName)
                            .font(Theme.heading(22))
                            .foregroundStyle(Theme.accent)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isFreeTier {
                        swipesRemainingBadge
                    }
                }
            }
            .task {
                await viewModel.loadProfiles()
            }
            .sheet(isPresented: $viewModel.showPaywall) {
                PaywallSheet()
            }
            .alert("New Connection!", isPresented: $viewModel.showMatchAlert) {
                Button("Send a Message") {
                    // TODO: Navigate to chat
                }
                Button("Keep Browsing", role: .cancel) {}
            } message: {
                if let user = viewModel.matchedUser {
                    Text("You and \(user.firstName) both want to grab coffee! Start a conversation about your shared interests.")
                }
            }
        }
    }

    // MARK: - Card Stack

    private var cardStack: some View {
        ZStack {
            // Show up to 3 cards stacked behind the current one
            ForEach(visibleCards, id: \.id) { profile in
                let cardIndex = viewModel.profiles.firstIndex(of: profile) ?? 0
                let offset = cardIndex - viewModel.currentIndex

                if offset == 0 {
                    SwipeCardView(
                        profile: profile,
                        onSwipeLeft: { viewModel.swipeLeft(on: profile) },
                        onSwipeRight: { viewModel.swipeRight(on: profile) }
                    )
                    .zIndex(Double(10 - offset))
                } else {
                    ProfileCardView(profile: profile)
                        .scaleEffect(1.0 - Double(offset) * 0.05)
                        .offset(y: CGFloat(offset) * 8)
                        .zIndex(Double(10 - offset))
                        .allowsHitTesting(false)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }

    private var visibleCards: [UserProfile] {
        let start = viewModel.currentIndex
        let end = min(start + 3, viewModel.profiles.count)
        guard start < end else { return [] }
        return Array(viewModel.profiles[start..<end])
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 32) {
            // Pass button
            Button {
                if let profile = viewModel.currentProfile {
                    viewModel.swipeLeft(on: profile)
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.red.opacity(0.7))
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            }

            // Connect button
            Button {
                if let profile = viewModel.currentProfile {
                    viewModel.swipeRight(on: profile)
                }
            } label: {
                CoffeeMugIcon(size: 32)
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Theme.primary.opacity(0.3), radius: 8, y: 3)
            }

            // Bookmark / save for later
            Button {
                // TODO: Save profile
            } label: {
                Image(systemName: "bookmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.accent.opacity(0.6))
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            }
        }
        .padding(.bottom, 8)
    }

    // MARK: - Supporting Views

    private var swipesRemainingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 11))
            Text("\(viewModel.swipesRemaining)")
                .font(Theme.caption(13))
        }
        .foregroundStyle(viewModel.swipesRemaining <= 2 ? Theme.warning : Theme.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Theme.blush)
        .clipShape(Capsule())
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Theme.primary)
                .scaleEffect(1.2)
            Text("Finding professionals near you...")
                .font(Theme.body(15))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.circle")
                .font(.system(size: 64))
                .foregroundStyle(Theme.primary.opacity(0.4))

            Text("You've seen everyone nearby!")
                .font(Theme.heading(22))
                .foregroundStyle(Theme.textPrimary)

            Text("Check back later for new professionals in your area, or upgrade to Pro to search other cities.")
                .font(Theme.body(15))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "Unlock More Cities", icon: "sparkles", style: .gradient) {
                viewModel.showPaywall = true
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Paywall Sheet

struct PaywallSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Theme.primary)

                            Text("ConnectHer Pro")
                                .font(Theme.heading(28))
                                .foregroundStyle(Theme.accent)

                            Text("Expand your professional network")
                                .font(Theme.body(16))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.top, 20)

                        // Features
                        VStack(spacing: 16) {
                            ProFeatureRow(icon: "infinity", title: "Unlimited Connections", description: "No daily limit on profiles you can view")
                            ProFeatureRow(icon: "map.fill", title: "Search Any City", description: "Connect with women in other geographies")
                            ProFeatureRow(icon: "line.3.horizontal.decrease.circle.fill", title: "Advanced Filters", description: "Filter by industry, role, and company size")
                            ProFeatureRow(icon: "eye.fill", title: "See Who Liked You", description: "Know who wants to connect before you swipe")
                            ProFeatureRow(icon: "star.fill", title: "Priority Visibility", description: "Your profile appears first in others' feeds")
                        }
                        .padding(.horizontal, 4)

                        // Pricing
                        VStack(spacing: 12) {
                            PricingOption(
                                title: "Yearly",
                                price: Constants.Subscription.yearlyPrice,
                                subtitle: "Just \(Constants.Subscription.yearlyMonthlyEquivalent)/month",
                                isRecommended: true
                            )

                            PricingOption(
                                title: "Monthly",
                                price: Constants.Subscription.monthlyPrice,
                                subtitle: "Billed monthly",
                                isRecommended: false
                            )
                        }

                        PrimaryButton(title: "Start Free Trial", icon: "sparkles", style: .gradient) {
                            // TODO: RevenueCat purchase
                            dismiss()
                        }

                        Text("Cancel anytime. 7-day free trial.")
                            .font(Theme.caption(12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(Theme.horizontalPadding)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
    }
}

struct ProFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Theme.primary)
                .frame(width: 40, height: 40)
                .background(Theme.blush)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.subheading(15))
                    .foregroundStyle(Theme.textPrimary)
                Text(description)
                    .font(Theme.caption(13))
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()
        }
    }
}

struct PricingOption: View {
    let title: String
    let price: String
    let subtitle: String
    let isRecommended: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(Theme.subheading(16))
                    if isRecommended {
                        Text("BEST VALUE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.primary)
                            .clipShape(Capsule())
                    }
                }
                Text(subtitle)
                    .font(Theme.caption(13))
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            Text(price)
                .font(Theme.heading(20))
                .foregroundStyle(Theme.accent)
        }
        .padding(16)
        .background(isRecommended ? Theme.blush : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isRecommended ? Theme.primary : Theme.divider, lineWidth: isRecommended ? 2 : 1)
        )
    }
}
