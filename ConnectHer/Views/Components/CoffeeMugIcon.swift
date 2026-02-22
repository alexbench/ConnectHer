import SwiftUI

/// A coffee mug with steam — the core ConnectHer icon.
struct CoffeeMugIcon: View {
    var size: CGFloat = 24

    var body: some View {
        ZStack {
            // Mug
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(Theme.primary)

            // Steam wisps
            SteamView(mugSize: size)
                .offset(y: -size * 0.52)
        }
    }
}

/// Animated steam wisps above the mug.
private struct SteamView: View {
    let mugSize: CGFloat
    @State private var animate = false

    var body: some View {
        HStack(spacing: mugSize * 0.08) {
            SteamWisp(height: mugSize * 0.28, delay: 0, animate: animate)
            SteamWisp(height: mugSize * 0.36, delay: 0.3, animate: animate)
            SteamWisp(height: mugSize * 0.28, delay: 0.6, animate: animate)
        }
        .onAppear {
            animate = true
        }
    }
}

/// A single wisp of steam.
private struct SteamWisp: View {
    let height: CGFloat
    let delay: Double
    let animate: Bool

    @State private var phase: CGFloat = 0

    var body: some View {
        Capsule()
            .fill(Theme.primary.opacity(0.3))
            .frame(width: 2, height: height)
            .offset(y: animate ? -2 : 2)
            .opacity(animate ? 0.6 : 0.2)
            .animation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
    }
}

#Preview {
    VStack(spacing: 32) {
        CoffeeMugIcon(size: 20)
        CoffeeMugIcon(size: 32)
        CoffeeMugIcon(size: 56)
    }
    .padding()
}
