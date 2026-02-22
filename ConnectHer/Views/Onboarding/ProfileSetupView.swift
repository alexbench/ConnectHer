import SwiftUI

struct ProfileSetupView: View {
    @Bindable var authVM: AuthViewModel
    @State private var currentStep = 0
    @State private var bio = ""
    @State private var selectedIndustries: Set<String> = []
    @State private var selectedRoles: Set<String> = []
    @State private var selectedInterests: Set<String> = []

    private let totalSteps = 4

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                progressBar
                    .padding(.horizontal, Theme.horizontalPadding)
                    .padding(.top, 8)

                // Step content
                TabView(selection: $currentStep) {
                    bioStep.tag(0)
                    industryStep.tag(1)
                    roleStep.tag(2)
                    interestsStep.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation buttons
                HStack(spacing: 12) {
                    if currentStep > 0 {
                        PrimaryButton(title: "Back", style: .outlined) {
                            withAnimation { currentStep -= 1 }
                        }
                    }

                    PrimaryButton(
                        title: currentStep == totalSteps - 1 ? "Get Started" : "Continue",
                        icon: currentStep == totalSteps - 1 ? "sparkles" : "arrow.right",
                        style: currentStep == totalSteps - 1 ? .gradient : .filled
                    ) {
                        if currentStep < totalSteps - 1 {
                            withAnimation { currentStep += 1 }
                        } else {
                            completeSetup()
                        }
                    }
                    .disabled(!canProceed)
                    .opacity(canProceed ? 1 : 0.5)
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.divider)
                    .frame(height: 4)

                Capsule()
                    .fill(Theme.primaryGradient)
                    .frame(width: geo.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
                    .animation(.easeInOut, value: currentStep)
            }
        }
        .frame(height: 4)
    }

    // MARK: - Steps

    private var bioStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            stepHeader(
                title: "Tell us about you",
                subtitle: "Write a short bio so others know what you're about"
            )

            TextEditor(text: $bio)
                .font(Theme.body(15))
                .frame(minHeight: 140)
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Theme.divider)
                )

            Text("\(bio.count)/\(Constants.Limits.maxBioLength)")
                .font(Theme.caption(12))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)

            Text("Tip: Mention what you're looking for — mentorship, co-founders, career advice, or just a friendly coffee chat!")
                .font(Theme.caption(13))
                .foregroundStyle(Theme.primary)
                .padding(12)
                .background(Theme.blush)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
        .padding(.top, 24)
    }

    private var industryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            stepHeader(
                title: "Your industry",
                subtitle: "Select one or more industries you work in"
            )

            ScrollView {
                FlowLayout(spacing: 8) {
                    ForEach(Constants.Industries.all, id: \.self) { industry in
                        SelectableTag(
                            text: industry,
                            isSelected: selectedIndustries.contains(industry)
                        ) {
                            toggle(industry, in: &selectedIndustries)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
        .padding(.top, 24)
    }

    private var roleStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            stepHeader(
                title: "Your career level",
                subtitle: "Where are you in your career journey?"
            )

            VStack(spacing: 8) {
                ForEach(Constants.Roles.all, id: \.self) { role in
                    Button {
                        toggle(role, in: &selectedRoles)
                    } label: {
                        HStack {
                            Text(role)
                                .font(Theme.body(15))
                                .foregroundStyle(selectedRoles.contains(role) ? .white : Theme.textPrimary)
                            Spacer()
                            if selectedRoles.contains(role) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(14)
                        .background(selectedRoles.contains(role) ? Theme.primary : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(selectedRoles.contains(role) ? Theme.primary : Theme.divider)
                        )
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
        .padding(.top, 24)
    }

    private var interestsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            stepHeader(
                title: "What do you want to connect about?",
                subtitle: "Pick at least 3 interests to help us find great matches"
            )

            ScrollView {
                FlowLayout(spacing: 8) {
                    ForEach(Constants.Interests.all, id: \.self) { interest in
                        SelectableTag(
                            text: interest,
                            isSelected: selectedInterests.contains(interest)
                        ) {
                            toggle(interest, in: &selectedInterests)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, Theme.horizontalPadding)
        .padding(.top, 24)
    }

    // MARK: - Helpers

    private func stepHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Theme.heading(24))
                .foregroundStyle(Theme.textPrimary)

            Text(subtitle)
                .font(Theme.body(15))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private func toggle(_ item: String, in set: inout Set<String>) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0: return bio.count >= 10
        case 1: return !selectedIndustries.isEmpty
        case 2: return !selectedRoles.isEmpty
        case 3: return selectedInterests.count >= 3
        default: return true
        }
    }

    private func completeSetup() {
        authVM.completeOnboarding(
            bio: bio,
            industries: Array(selectedIndustries),
            roles: Array(selectedRoles),
            interests: Array(selectedInterests)
        )
    }
}

struct SelectableTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(Theme.caption(14))
                .foregroundStyle(isSelected ? .white : Theme.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Theme.primary : Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Theme.primary : Theme.divider)
                )
        }
    }
}
