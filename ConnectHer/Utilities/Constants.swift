import Foundation

enum Constants {
    static let appName = "ConnectHer"
    static let tagline = "Where ambitious women connect"

    enum Limits {
        static let freeSwipesPerDay = 8
        static let freeRadiusMiles: Double = 25
        static let proRadiusMiles: Double = 150
        static let maxBioLength = 300
        static let maxInterests = 10
    }

    enum Subscription {
        static let monthlyPrice = "$9.99"
        static let yearlyPrice = "$59.99"
        static let yearlyMonthlyEquivalent = "$4.99"
    }

    enum Industries: CaseIterable {
        static let all = [
            "Technology", "Finance", "Healthcare", "Education",
            "Marketing", "Legal", "Consulting", "Media & Entertainment",
            "Real Estate", "Non-Profit", "Government", "Retail",
            "Manufacturing", "Energy", "Hospitality", "Science & Research"
        ]
    }

    enum Roles: CaseIterable {
        static let all = [
            "Executive / C-Suite", "VP / Director", "Manager",
            "Individual Contributor", "Founder / Entrepreneur",
            "Freelancer / Consultant", "Student", "Career Changer"
        ]
    }

    enum Interests: CaseIterable {
        static let all = [
            "Mentorship", "Career Growth", "Leadership",
            "Networking", "Side Projects", "Public Speaking",
            "Work-Life Balance", "Negotiation", "Investing",
            "Startup Life", "Remote Work", "Diversity & Inclusion",
            "Personal Branding", "Career Pivoting", "Management Skills",
            "Industry Trends", "Book Club", "Wellness"
        ]
    }
}
