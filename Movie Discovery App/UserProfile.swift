import Foundation

// Requirement 4.2: Entity for User Profile
struct UserProfile: Codable {
    var displayName: String
    var bio: String
    var favoriteGenre: String
}
