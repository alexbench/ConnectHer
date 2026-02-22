import Foundation

/// Provides realistic mock data for development and testing.
enum MockData {

    // MARK: - Current User

    static let currentUser = UserProfile(
        id: "current-user",
        firstName: "You",
        lastName: "",
        headline: "Product Manager at Stripe",
        company: "Stripe",
        profilePhotoURL: nil,
        emailAddress: "you@example.com",
        bio: "Passionate about building products that empower people.",
        industries: ["Technology", "Finance"],
        roles: ["Manager"],
        interests: ["Leadership", "Career Growth", "Mentorship"],
        latitude: 37.7749,
        longitude: -122.4194,
        city: "San Francisco",
        state: "CA",
        subscriptionTier: .free,
        dailySwipesRemaining: 8,
        lastSwipeReset: Date(),
        createdAt: Date(),
        lastActive: Date()
    )

    // MARK: - Discover Profiles

    static let discoverProfiles: [UserProfile] = [
        UserProfile(
            id: "user-1",
            firstName: "Priya",
            lastName: "Sharma",
            headline: "Engineering Manager at Google",
            company: "Google",
            profilePhotoURL: nil,
            emailAddress: "priya@example.com",
            bio: "Building inclusive engineering teams. Love hiking, mentoring early-career women in tech, and exploring SF's food scene.",
            industries: ["Technology"],
            roles: ["Manager"],
            interests: ["Leadership", "Mentorship", "Diversity & Inclusion"],
            latitude: 37.7849,
            longitude: -122.4094,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .free,
            dailySwipesRemaining: 8,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 30),
            lastActive: Date()
        ),
        UserProfile(
            id: "user-2",
            firstName: "Maya",
            lastName: "Johnson",
            headline: "Founder & CEO at Bloom Health",
            company: "Bloom Health",
            profilePhotoURL: nil,
            emailAddress: "maya@example.com",
            bio: "Serial entrepreneur on my third startup. Always looking for fellow founders to grab coffee and swap war stories.",
            industries: ["Healthcare", "Technology"],
            roles: ["Founder / Entrepreneur"],
            interests: ["Startup Life", "Networking", "Investing"],
            latitude: 37.7649,
            longitude: -122.4294,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .pro,
            dailySwipesRemaining: .max,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 60),
            lastActive: Date()
        ),
        UserProfile(
            id: "user-3",
            firstName: "Sofia",
            lastName: "Martinez",
            headline: "VP of Marketing at Salesforce",
            company: "Salesforce",
            profilePhotoURL: nil,
            emailAddress: "sofia@example.com",
            bio: "Marketing leader passionate about storytelling and brand. Looking for women in leadership to share experiences with.",
            industries: ["Technology", "Marketing"],
            roles: ["VP / Director"],
            interests: ["Leadership", "Personal Branding", "Public Speaking"],
            latitude: 37.7900,
            longitude: -122.3900,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .free,
            dailySwipesRemaining: 5,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 14),
            lastActive: Date().addingTimeInterval(-3600)
        ),
        UserProfile(
            id: "user-4",
            firstName: "Amara",
            lastName: "Obi",
            headline: "Senior Data Scientist at Netflix",
            company: "Netflix",
            profilePhotoURL: nil,
            emailAddress: "amara@example.com",
            bio: "Data nerd who believes in the power of numbers. Transitioning into management and would love advice from women who've done it.",
            industries: ["Technology", "Media & Entertainment"],
            roles: ["Individual Contributor"],
            interests: ["Career Growth", "Management Skills", "Book Club"],
            latitude: 37.7550,
            longitude: -122.4050,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .free,
            dailySwipesRemaining: 8,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 7),
            lastActive: Date().addingTimeInterval(-7200)
        ),
        UserProfile(
            id: "user-5",
            firstName: "Rachel",
            lastName: "Kim",
            headline: "Partner at Sequoia Capital",
            company: "Sequoia Capital",
            profilePhotoURL: nil,
            emailAddress: "rachel@example.com",
            bio: "Investing in the next generation of great companies. Advocate for more women in VC. Coffee is my love language.",
            industries: ["Finance", "Technology"],
            roles: ["Executive / C-Suite"],
            interests: ["Investing", "Networking", "Mentorship"],
            latitude: 37.4419,
            longitude: -122.1430,
            city: "Palo Alto",
            state: "CA",
            subscriptionTier: .pro,
            dailySwipesRemaining: .max,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 90),
            lastActive: Date()
        ),
        UserProfile(
            id: "user-6",
            firstName: "Jasmine",
            lastName: "Chen",
            headline: "UX Design Lead at Figma",
            company: "Figma",
            profilePhotoURL: nil,
            emailAddress: "jasmine@example.com",
            bio: "Designing for delight. I run a women-in-design meetup and I'm always looking for speakers and collaborators.",
            industries: ["Technology"],
            roles: ["Manager"],
            interests: ["Networking", "Public Speaking", "Side Projects"],
            latitude: 37.7800,
            longitude: -122.4000,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .free,
            dailySwipesRemaining: 3,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 45),
            lastActive: Date().addingTimeInterval(-1800)
        ),
        UserProfile(
            id: "user-7",
            firstName: "Daniella",
            lastName: "Wright",
            headline: "General Counsel at Airbnb",
            company: "Airbnb",
            profilePhotoURL: nil,
            emailAddress: "daniella@example.com",
            bio: "Tech lawyer turned GC. Navigating the intersection of law and innovation. Would love to connect with other women in legal leadership.",
            industries: ["Legal", "Technology"],
            roles: ["Executive / C-Suite"],
            interests: ["Leadership", "Work-Life Balance", "Negotiation"],
            latitude: 37.7710,
            longitude: -122.4130,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .free,
            dailySwipesRemaining: 8,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 20),
            lastActive: Date().addingTimeInterval(-600)
        ),
        UserProfile(
            id: "user-8",
            firstName: "Nia",
            lastName: "Thompson",
            headline: "Chief People Officer at Notion",
            company: "Notion",
            profilePhotoURL: nil,
            emailAddress: "nia@example.com",
            bio: "Building the future of work, one culture initiative at a time. Passionate about equity and helping women negotiate what they deserve.",
            industries: ["Technology"],
            roles: ["Executive / C-Suite"],
            interests: ["Diversity & Inclusion", "Negotiation", "Wellness"],
            latitude: 37.7830,
            longitude: -122.3950,
            city: "San Francisco",
            state: "CA",
            subscriptionTier: .pro,
            dailySwipesRemaining: .max,
            lastSwipeReset: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 55),
            lastActive: Date()
        )
    ]

    // MARK: - Matches

    static let matches: [Match] = [
        Match(
            id: "match-1",
            userId1: "current-user",
            userId2: "user-1",
            status: .mutual,
            user1Liked: true,
            user2Liked: true,
            createdAt: Date().addingTimeInterval(-86400 * 2),
            lastMessageAt: Date().addingTimeInterval(-3600)
        ),
        Match(
            id: "match-2",
            userId1: "current-user",
            userId2: "user-2",
            status: .mutual,
            user1Liked: true,
            user2Liked: true,
            createdAt: Date().addingTimeInterval(-86400 * 5),
            lastMessageAt: Date().addingTimeInterval(-86400)
        ),
        Match(
            id: "match-3",
            userId1: "user-3",
            userId2: "current-user",
            status: .mutual,
            user1Liked: true,
            user2Liked: true,
            createdAt: Date().addingTimeInterval(-86400),
            lastMessageAt: nil
        )
    ]

    // MARK: - Messages

    static let messagesForMatch1: [Message] = [
        Message(id: "msg-1", matchId: "match-1", senderId: "user-1", text: "Hi! I saw you're in product at Stripe — I'd love to chat about cross-functional leadership. Coffee sometime?", sentAt: Date().addingTimeInterval(-86400 * 2), isRead: true),
        Message(id: "msg-2", matchId: "match-1", senderId: "current-user", text: "Absolutely! I've been wanting to connect with engineering leaders. How about Blue Bottle on Thursday?", sentAt: Date().addingTimeInterval(-86400 * 2 + 3600), isRead: true),
        Message(id: "msg-3", matchId: "match-1", senderId: "user-1", text: "Perfect! Thursday at 10am works for me. See you there!", sentAt: Date().addingTimeInterval(-86400 + 1800), isRead: true),
        Message(id: "msg-4", matchId: "match-1", senderId: "user-1", text: "Looking forward to it! 🙌", sentAt: Date().addingTimeInterval(-3600), isRead: false)
    ]

    static let messagesForMatch2: [Message] = [
        Message(id: "msg-5", matchId: "match-2", senderId: "current-user", text: "Hey Maya! Fellow founder here — well, aspiring. Would love to hear about your journey starting Bloom Health.", sentAt: Date().addingTimeInterval(-86400 * 4), isRead: true),
        Message(id: "msg-6", matchId: "match-2", senderId: "user-2", text: "Always happy to chat with aspiring founders! The journey is wild but so worth it. What's your idea?", sentAt: Date().addingTimeInterval(-86400 * 3), isRead: true)
    ]

    // MARK: - Conversations

    static let conversations: [Conversation] = [
        Conversation(
            id: "match-1",
            match: matches[0],
            otherUser: discoverProfiles[0],
            lastMessage: messagesForMatch1.last,
            unreadCount: 1
        ),
        Conversation(
            id: "match-2",
            match: matches[1],
            otherUser: discoverProfiles[1],
            lastMessage: messagesForMatch2.last,
            unreadCount: 0
        ),
        Conversation(
            id: "match-3",
            match: matches[2],
            otherUser: discoverProfiles[2],
            lastMessage: nil,
            unreadCount: 0
        )
    ]
}
