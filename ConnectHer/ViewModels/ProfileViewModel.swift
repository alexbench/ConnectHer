import Foundation

@Observable
@MainActor
final class ProfileViewModel {
    var user: UserProfile
    var isEditing = false
    var showDeleteConfirmation = false
    var showSubscription = false

    init(user: UserProfile = MockData.currentUser) {
        self.user = user
    }

    func updateProfile(bio: String, industries: [String], roles: [String], interests: [String]) {
        user.bio = bio
        user.industries = industries
        user.roles = roles
        user.interests = interests
        isEditing = false
        // TODO: Save to Firestore
    }

    func upgradeToPro() {
        user.subscriptionTier = .pro
        user.dailySwipesRemaining = .max
        // TODO: RevenueCat purchase
    }
}
