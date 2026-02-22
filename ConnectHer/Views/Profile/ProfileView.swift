import SwiftUI

struct ProfileView: View {
    @Bindable var profileVM: ProfileViewModel
    let onSignOut: () -> Void

    @State private var showEditProfile = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        profileHeader
                        subscriptionCard
                        settingsSection
                        signOutSection
                    }
                    .padding(Theme.horizontalPadding)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(profileVM: profileVM)
            }
            .sheet(isPresented: $profileVM.showSubscription) {
                PaywallSheet()
            }
            .alert("Delete Account", isPresented: $profileVM.showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    profileVM.user = MockData.currentUser
                    onSignOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete your account and all your data. This action cannot be undone.")
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: 14) {
            // Avatar
            Circle()
                .fill(Theme.primaryGradient)
                .frame(width: 90, height: 90)
                .overlay {
                    Text(profileVM.user.firstName.prefix(1))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(spacing: 4) {
                Text(profileVM.user.fullName)
                    .font(Theme.heading(22))
                    .foregroundStyle(Theme.textPrimary)

                Text(profileVM.user.headline)
                    .font(Theme.body(15))
                    .foregroundStyle(Theme.textSecondary)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                    Text(profileVM.user.locationString)
                        .font(Theme.caption(13))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.top, 2)
            }

            PrimaryButton(title: "Edit Profile", icon: "pencil", style: .outlined) {
                showEditProfile = true
            }
            .frame(width: 180)
        }
        .padding(.vertical, 16)
    }

    // MARK: - Subscription Card

    private var subscriptionCard: some View {
        Button {
            if profileVM.user.subscriptionTier == .free {
                profileVM.showSubscription = true
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: profileVM.user.subscriptionTier == .pro ? "crown.fill" : "sparkles")
                            .font(.system(size: 16))
                        Text(profileVM.user.subscriptionTier == .pro ? "ConnectHer Pro" : "Free Plan")
                            .font(Theme.subheading(16))
                    }

                    Text(profileVM.user.subscriptionTier == .pro
                         ? "You have unlimited access"
                         : "Upgrade for unlimited connections")
                        .font(Theme.caption(13))
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                if profileVM.user.subscriptionTier == .free {
                    Text("Upgrade")
                        .font(Theme.caption(13))
                        .foregroundStyle(Theme.accent)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(.white)
            .padding(16)
            .background(Theme.proGradient)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "bell.fill", title: "Notifications", color: Theme.primary) {}
            Divider().background(Theme.divider).padding(.leading, 52)
            SettingsRow(icon: "lock.fill", title: "Privacy", color: Theme.accent) {}
            Divider().background(Theme.divider).padding(.leading, 52)
            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: Theme.success) {}
            Divider().background(Theme.divider).padding(.leading, 52)
            SettingsRow(icon: "doc.text.fill", title: "Terms & Privacy Policy", color: Theme.textSecondary) {}
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Sign Out

    private var signOutSection: some View {
        VStack(spacing: 0) {
            Button {
                onSignOut()
            } label: {
                HStack {
                    Text("Sign Out")
                        .font(Theme.body(16))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                }
                .padding(16)
            }

            Divider().background(Theme.divider).padding(.leading, 16)

            Button {
                profileVM.showDeleteConfirmation = true
            } label: {
                HStack {
                    Text("Delete Account")
                        .font(Theme.body(16))
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(16)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
                    .frame(width: 28)

                Text(title)
                    .font(Theme.body(15))
                    .foregroundStyle(Theme.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.textSecondary.opacity(0.5))
            }
            .padding(16)
        }
    }
}

// MARK: - Edit Profile

struct EditProfileView: View {
    @Bindable var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var bio: String = ""
    @State private var selectedIndustries: Set<String> = []
    @State private var selectedRoles: Set<String> = []
    @State private var selectedInterests: Set<String> = []

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Bio
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(Theme.subheading(16))
                                .foregroundStyle(Theme.accent)

                            TextEditor(text: $bio)
                                .font(Theme.body(15))
                                .frame(minHeight: 100)
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
                        }

                        // Industries
                        MultiSelectSection(
                            title: "Industries",
                            options: Constants.Industries.all,
                            selected: $selectedIndustries
                        )

                        // Roles
                        MultiSelectSection(
                            title: "Career Level",
                            options: Constants.Roles.all,
                            selected: $selectedRoles
                        )

                        // Interests
                        MultiSelectSection(
                            title: "Interests",
                            options: Constants.Interests.all,
                            selected: $selectedInterests
                        )
                    }
                    .padding(Theme.horizontalPadding)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        profileVM.updateProfile(
                            bio: bio,
                            industries: Array(selectedIndustries),
                            roles: Array(selectedRoles),
                            interests: Array(selectedInterests)
                        )
                        dismiss()
                    }
                    .font(Theme.subheading(16))
                    .foregroundStyle(Theme.primary)
                }
            }
            .onAppear {
                bio = profileVM.user.bio ?? ""
                selectedIndustries = Set(profileVM.user.industries)
                selectedRoles = Set(profileVM.user.roles)
                selectedInterests = Set(profileVM.user.interests)
            }
        }
    }
}

struct MultiSelectSection: View {
    let title: String
    let options: [String]
    @Binding var selected: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.subheading(16))
                .foregroundStyle(Theme.accent)

            FlowLayout(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selected.contains(option)
                    Button {
                        if isSelected {
                            selected.remove(option)
                        } else {
                            selected.insert(option)
                        }
                    } label: {
                        Text(option)
                            .font(Theme.caption(13))
                            .foregroundStyle(isSelected ? .white : Theme.textPrimary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(isSelected ? Theme.primary : Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(isSelected ? Theme.primary : Theme.divider)
                            )
                    }
                }
            }
        }
    }
}
