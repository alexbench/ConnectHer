import Foundation
import SwiftUI

@Observable
@MainActor
final class DiscoverViewModel {
    var profiles: [UserProfile] = []
    var currentIndex = 0
    var swipesRemaining: Int
    var showPaywall = false
    var showMatchAlert = false
    var matchedUser: UserProfile?
    var isLoading = false

    private let subscriptionTier: SubscriptionTier
    private let dailyLimit: Int

    init(subscriptionTier: SubscriptionTier = .free) {
        self.subscriptionTier = subscriptionTier
        self.dailyLimit = subscriptionTier.dailySwipeLimit
        self.swipesRemaining = subscriptionTier.dailySwipeLimit
    }

    var currentProfile: UserProfile? {
        guard currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }

    var hasProfiles: Bool {
        currentIndex < profiles.count
    }

    var isFreeTier: Bool {
        subscriptionTier == .free
    }

    func loadProfiles() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 800_000_000)
        profiles = MockData.discoverProfiles.shuffled()
        currentIndex = 0
        isLoading = false
    }

    func swipeRight(on profile: UserProfile) {
        guard canSwipe else {
            showPaywall = true
            return
        }

        consumeSwipe()

        // Simulate a ~40% match rate for demo purposes
        let isMatch = Int.random(in: 0..<10) < 4
        if isMatch {
            matchedUser = profile
            showMatchAlert = true
        }

        advanceToNext()
    }

    func swipeLeft(on profile: UserProfile) {
        guard canSwipe else {
            showPaywall = true
            return
        }

        consumeSwipe()
        advanceToNext()
    }

    // MARK: - Private

    private var canSwipe: Bool {
        subscriptionTier == .pro || swipesRemaining > 0
    }

    private func consumeSwipe() {
        if subscriptionTier == .free {
            swipesRemaining = max(0, swipesRemaining - 1)
        }
    }

    private func advanceToNext() {
        withAnimation(.spring(response: 0.4)) {
            currentIndex += 1
        }
    }
}
