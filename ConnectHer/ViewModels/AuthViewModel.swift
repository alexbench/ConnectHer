import Foundation
import SwiftUI

@Observable
@MainActor
final class AuthViewModel {
    var isAuthenticated = false
    var isLoading = false
    var currentUser: UserProfile?
    var hasCompletedOnboarding = false

    /// Check if user was previously signed in.
    func checkSession() {
        // TODO: Check Firebase Auth session
        // For now, check UserDefaults flag
        if UserDefaults.standard.bool(forKey: "isAuthenticated") {
            isAuthenticated = true
            hasCompletedOnboarding = true
            currentUser = MockData.currentUser
        }
    }

    /// Sign in with LinkedIn (mock for now).
    func signInWithLinkedIn() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        currentUser = MockData.currentUser
        isLoading = false
    }

    /// Complete profile setup and finish onboarding.
    func completeOnboarding(
        bio: String,
        industries: [String],
        roles: [String],
        interests: [String]
    ) {
        currentUser?.bio = bio
        currentUser?.industries = industries
        currentUser?.roles = roles
        currentUser?.interests = interests

        isAuthenticated = true
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
    }

    func signOut() {
        isAuthenticated = false
        hasCompletedOnboarding = false
        currentUser = nil
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
    }

    func deleteAccount() {
        // TODO: Delete from Firebase
        signOut()
    }
}
