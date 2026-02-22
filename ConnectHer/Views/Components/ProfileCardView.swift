import SwiftUI

struct ProfileCardView: View {
    let profile: UserProfile
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Profile photo area
            ZStack(alignment: .bottomLeading) {
                // Placeholder avatar with gradient
                LinearGradient(
                    colors: avatarColors(for: profile.firstName),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay {
                    Text(profile.firstName.prefix(1))
                        .font(.system(size: compact ? 48 : 80, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }

                // Bottom gradient overlay for text readability
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // Name and headline overlay
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.firstName)
                        .font(Theme.heading(compact ? 22 : 28))
                        .foregroundStyle(.white)

                    Text(profile.headline)
                        .font(Theme.body(compact ? 13 : 15))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                        Text(profile.locationString)
                            .font(Theme.caption(12))
                    }
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding(compact ? 12 : 20)
            }
            .frame(height: compact ? 200 : 380)

            if !compact {
                // Bio section
                VStack(alignment: .leading, spacing: 12) {
                    if let bio = profile.bio, !bio.isEmpty {
                        Text(bio)
                            .font(Theme.body(15))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(3)
                    }

                    // Interests tags
                    FlowLayout(spacing: 6) {
                        ForEach(profile.interests, id: \.self) { interest in
                            InterestTag(text: interest)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }

    private func avatarColors(for name: String) -> [Color] {
        let palettes: [[Color]] = [
            [Color(hex: "E8636F"), Color(hex: "D4507A")],
            [Color(hex: "6B2D5B"), Color(hex: "9B4DCA")],
            [Color(hex: "4ECDC4"), Color(hex: "44B4A6")],
            [Color(hex: "F7B731"), Color(hex: "EB9C1D")],
            [Color(hex: "7C5CFC"), Color(hex: "5A3FD9")],
            [Color(hex: "FF6B6B"), Color(hex: "EE5A24")],
            [Color(hex: "2D9CDB"), Color(hex: "2672A0")],
            [Color(hex: "F78FB3"), Color(hex: "E66C9A")]
        ]
        let index = abs(name.hashValue) % palettes.count
        return palettes[index]
    }
}

struct InterestTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Theme.caption(12))
            .foregroundStyle(Theme.accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Theme.blush)
            .clipShape(Capsule())
    }
}

/// Simple flow layout for tags that wrap to the next line.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}

#Preview {
    ProfileCardView(profile: MockData.discoverProfiles[0])
        .padding()
}
