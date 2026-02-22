import SwiftUI

struct SwipeCardView: View {
    let profile: UserProfile
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void

    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0

    private let swipeThreshold: CGFloat = 120

    var body: some View {
        ProfileCardView(profile: profile)
            .overlay(alignment: .top) {
                swipeIndicator
            }
            .offset(x: offset.width, y: offset.height * 0.3)
            .rotationEffect(.degrees(rotation))
            .gesture(dragGesture)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: offset)
    }

    // MARK: - Swipe Indicator Overlay

    @ViewBuilder
    private var swipeIndicator: some View {
        ZStack {
            // "Coffee?" indicator (right swipe)
            HStack(spacing: 6) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 24, weight: .bold))
                Text("COFFEE?")
                    .font(.system(size: 28, weight: .black, design: .rounded))
            }
                .foregroundStyle(Theme.success)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Theme.success, lineWidth: 3)
                )
                .rotationEffect(.degrees(-15))
                .opacity(rightSwipeOpacity)
                .padding(.top, 40)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)

            // "Pass" indicator (left swipe)
            Text("PASS")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(.red.opacity(0.8))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.red.opacity(0.8), lineWidth: 3)
                )
                .rotationEffect(.degrees(15))
                .opacity(leftSwipeOpacity)
                .padding(.top, 40)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    // MARK: - Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
                rotation = Double(value.translation.width / 20)
            }
            .onEnded { value in
                if value.translation.width > swipeThreshold {
                    swipeOffScreen(direction: .right)
                } else if value.translation.width < -swipeThreshold {
                    swipeOffScreen(direction: .left)
                } else {
                    resetPosition()
                }
            }
    }

    // MARK: - Helpers

    private var rightSwipeOpacity: Double {
        min(Double(offset.width / swipeThreshold), 1.0)
    }

    private var leftSwipeOpacity: Double {
        min(Double(-offset.width / swipeThreshold), 1.0)
    }

    private func swipeOffScreen(direction: SwipeDirection) {
        let screenWidth = UIScreen.main.bounds.width
        withAnimation(.easeOut(duration: 0.3)) {
            offset = CGSize(
                width: direction == .right ? screenWidth * 1.5 : -screenWidth * 1.5,
                height: offset.height
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if direction == .right {
                onSwipeRight()
            } else {
                onSwipeLeft()
            }
        }
    }

    private func resetPosition() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            offset = .zero
            rotation = 0
        }
    }
}

private enum SwipeDirection {
    case left, right
}
