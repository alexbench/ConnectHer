import SwiftUI

/// ConnectHer brand theme — female-forward, warm, professional.
enum Theme {
    // MARK: - Brand Colors

    /// Warm coral — primary action color
    static let primary = Color(hex: "E8636F")

    /// Deep plum — headings, accents
    static let accent = Color(hex: "6B2D5B")

    /// Soft blush — card backgrounds, highlights
    static let blush = Color(hex: "FFF0F0")

    /// Warm cream — page background
    static let background = Color(hex: "FFF8F6")

    /// Charcoal — body text
    static let textPrimary = Color(hex: "2D2D3A")

    /// Medium gray — secondary text
    static let textSecondary = Color(hex: "8E8E9A")

    /// Light divider
    static let divider = Color(hex: "F0E8E6")

    /// Success / mutual match
    static let success = Color(hex: "4ECDC4")

    /// Warning / limit reached
    static let warning = Color(hex: "F7B731")

    // MARK: - Gradients

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "E8636F"), Color(hex: "D4507A")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [Color.white, Color(hex: "FFF8F6")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let proGradient = LinearGradient(
        colors: [Color(hex: "6B2D5B"), Color(hex: "E8636F")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Typography

    static func heading(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func subheading(_ size: CGFloat = 18) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    // MARK: - Shadows

    static let cardShadow: some View = Color.black.opacity(0.08)

    // MARK: - Layout

    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 28
    static let horizontalPadding: CGFloat = 20
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
