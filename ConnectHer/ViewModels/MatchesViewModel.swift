import Foundation

@Observable
@MainActor
final class MatchesViewModel {
    var matches: [Match] = []
    var matchedProfiles: [String: UserProfile] = [:]
    var isLoading = false

    func loadMatches() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)

        matches = MockData.matches.filter { $0.status == .mutual }

        // Build a lookup from user ID → profile
        for profile in MockData.discoverProfiles {
            matchedProfiles[profile.id] = profile
        }

        isLoading = false
    }

    func profileFor(match: Match) -> UserProfile? {
        let otherId = match.otherUserId(currentUserId: MockData.currentUser.id)
        return matchedProfiles[otherId]
    }
}
