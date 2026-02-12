import Foundation

// Requirement 4.4: Robust error handling (timeouts, no internet, etc.)
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case offline
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The server URL is invalid."
        case .noData: return "No response from the movie server."
        case .decodingError: return "Failed to read movie data."
        case .serverError(let code): return "Server error: \(code). Please try again."
        case .offline: return "You appear to be offline. Check your connection."
        }
    }
}
