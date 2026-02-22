import Foundation
import SwiftUI

struct UserProfile: Codable, Identifiable, Hashable {
    let id: String
    var firstName: String
    var lastName: String
    var headline: String
    var company: String?
    var profilePhotoURL: String?
    var emailAddress: String

    // App-specific data
    var bio: String?
    var industries: [String]
    var roles: [String]
    var interests: [String]
    var latitude: Double
    var longitude: Double
    var city: String
    var state: String

    // Subscription
    var subscriptionTier: SubscriptionTier
    var dailySwipesRemaining: Int
    var lastSwipeReset: Date

    var createdAt: Date
    var lastActive: Date

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    var locationString: String {
        "\(city), \(state)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }
}

enum SubscriptionTier: String, Codable, CaseIterable {
    case free
    case pro

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .pro: return "Pro"
        }
    }

    var dailySwipeLimit: Int {
        switch self {
        case .free: return 8
        case .pro: return .max
        }
    }

    var searchRadiusMiles: Double {
        switch self {
        case .free: return 25
        case .pro: return 150
        }
    }
}
