import SwiftUI

struct OnboardingView: View {
    @Bindable var authVM: AuthViewModel
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    howItWorksPage.tag(1)
                    signInPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                // Page indicator + button
                VStack(spacing: 20) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(index == currentPage ? Theme.primary : Theme.divider)
                                .frame(width: 8, height: 8)
                        }
                    }

                    if currentPage < 2 {
                        PrimaryButton(title: "Next", icon: "arrow.right") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Page 1: Welcome

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo area
            ZStack {
                Circle()
                    .fill(Theme.blush)
                    .frame(width: 140, height: 140)

                CoffeeMugIcon(size: 56)
            }

            VStack(spacing: 12) {
                Text(Constants.appName)
                    .font(Theme.heading(36))
                    .foregroundStyle(Theme.accent)

                Text(Constants.tagline)
                    .font(Theme.subheading(18))
                    .foregroundStyle(Theme.textSecondary)
            }

            Text("Build meaningful professional relationships with women in your city through casual meetups and coffee chats.")
                .font(Theme.body(16))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Page 2: How It Works

    private var howItWorksPage: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("How It Works")
                .font(Theme.heading(28))
                .foregroundStyle(Theme.accent)

            VStack(spacing: 24) {
                OnboardingStep(
                    number: 1,
                    icon: "person.crop.circle.fill",
                    title: "Create Your Profile",
                    description: "Connect with LinkedIn or enter your details manually"
                )

                OnboardingStep(
                    number: 2,
                    icon: "hand.tap.fill",
                    title: "Discover & Connect",
                    description: "Swipe through professionals near you and find your people"
                )

                OnboardingStep(
                    number: 3,
                    icon: "cup.and.saucer.fill",
                    title: "Meet Up",
                    description: "Chat, plan, and meet for coffee or lunch in person"
                )
            }
            .padding(.horizontal, 8)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
    }

    // MARK: - Page 3: Sign In

    private var signInPage: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("Let's Get Started")
                    .font(Theme.heading(28))
                    .foregroundStyle(Theme.accent)

                Text("Join thousands of professional women building their network")
                    .font(Theme.body(16))
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 14) {
                // LinkedIn button
                PrimaryButton(
                    title: "Continue with LinkedIn",
                    icon: "link",
                    style: .gradient,
                    isLoading: authVM.isLoading
                ) {
                    Task { await authVM.signInWithLinkedIn() }
                }

                // Manual entry
                PrimaryButton(
                    title: "Enter Details Manually",
                    style: .outlined
                ) {
                    // Skip LinkedIn, go straight to profile setup
                    authVM.currentUser = MockData.currentUser
                }
            }
            .padding(.horizontal, 8)

            Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                .font(Theme.caption(12))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
    }
}

struct OnboardingStep: View {
    let number: Int
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.blush)
                    .frame(width: 52, height: 52)

                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.primary)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(Theme.subheading(16))
                    .foregroundStyle(Theme.textPrimary)

                Text(description)
                    .font(Theme.body(14))
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()
        }
    }
}
