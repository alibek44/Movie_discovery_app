import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    let userId: String     // Missing in your screenshot
    let userEmail: String
    let text: String
    let timestamp: Double  // Missing in your screenshot
}
