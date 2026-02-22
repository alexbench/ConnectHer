import SwiftUI

struct ProfileDetailView: View {
    let profile: UserProfile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with avatar
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        colors: avatarColors(for: profile.firstName),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 320)
                    .overlay {
                        Text(profile.firstName.prefix(1))
                            .font(.system(size: 100, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    // Close button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(16)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    // Name & headline
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.fullName)
                            .font(Theme.heading(26))
                            .foregroundStyle(Theme.textPrimary)

                        Text(profile.headline)
                            .font(Theme.body(16))
                            .foregroundStyle(Theme.textSecondary)

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 14))
                            Text(profile.locationString)
                                .font(Theme.caption(14))
                        }
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.top, 4)
                    }

                    Divider().background(Theme.divider)

                    // Bio
                    if let bio = profile.bio, !bio.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(Theme.subheading(16))
                                .foregroundStyle(Theme.accent)
                            Text(bio)
                                .font(Theme.body(15))
                                .foregroundStyle(Theme.textPrimary)
                        }
                    }

                    // Industry
                    if !profile.industries.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Industry")
                                .font(Theme.subheading(16))
                                .foregroundStyle(Theme.accent)
                            FlowLayout(spacing: 6) {
                                ForEach(profile.industries, id: \.self) { industry in
                                    InterestTag(text: industry)
                                }
                            }
                        }
                    }

                    // Looking to connect about
                    if !profile.interests.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Looking to connect about")
                                .font(Theme.subheading(16))
                                .foregroundStyle(Theme.accent)
                            FlowLayout(spacing: 6) {
                                ForEach(profile.interests, id: \.self) { interest in
                                    InterestTag(text: interest)
                                }
                            }
                        }
                    }

                    // Role
                    if !profile.roles.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Career level")
                                .font(Theme.subheading(16))
                                .foregroundStyle(Theme.accent)
                            FlowLayout(spacing: 6) {
                                ForEach(profile.roles, id: \.self) { role in
                                    InterestTag(text: role)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Theme.background)
    }

    private func avatarColors(for name: String) -> [Color] {
        let palettes: [[Color]] = [
            [Color(hex: "E8636F"), Color(hex: "D4507A")],
            [Color(hex: "6B2D5B"), Color(hex: "9B4DCA")],
            [Color(hex: "4ECDC4"), Color(hex: "44B4A6")],
            [Color(hex: "F7B731"), Color(hex: "EB9C1D")],
            [Color(hex: "7C5CFC"), Color(hex: "5A3FD9")],
        ]
        let index = abs(name.hashValue) % palettes.count
        return palettes[index]
    }
}
