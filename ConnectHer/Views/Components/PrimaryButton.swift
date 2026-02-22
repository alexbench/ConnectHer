import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var style: Style = .filled
    var isLoading: Bool = false
    let action: () -> Void

    enum Style {
        case filled, outlined, gradient
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(style == .outlined ? Theme.primary : .white)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(Theme.subheading(16))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(foregroundColor)
            .background(background)
            .clipShape(Capsule())
            .overlay {
                if style == .outlined {
                    Capsule()
                        .strokeBorder(Theme.primary, lineWidth: 2)
                }
            }
        }
        .disabled(isLoading)
    }

    private var foregroundColor: Color {
        style == .outlined ? Theme.primary : .white
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            Theme.primary
        case .outlined:
            Color.clear
        case .gradient:
            Theme.primaryGradient
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", icon: "arrow.right", action: {})
        PrimaryButton(title: "Sign in with LinkedIn", icon: "link", style: .gradient, action: {})
        PrimaryButton(title: "Skip for Now", style: .outlined, action: {})
        PrimaryButton(title: "Loading...", isLoading: true, action: {})
    }
    .padding()
}
