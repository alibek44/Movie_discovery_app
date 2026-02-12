import Foundation
import Combine
import OSLog

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = ""
    
    private let logger = Logger(subsystem: "com.astana.MovieDiscovery", category: "Networking")
    private var lastFailedAction: (() async -> Void)?

    func loadTrending() async {
        // Prevent multiple simultaneous loads
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Requirement 4.8: Using the Repository singleton
            let fetchedMovies = try await MovieRepository.shared.getTrendingMovies(page: 1)
            self.movies = fetchedMovies
        } catch {
            self.errorMessage = "Failed to load movies. Check your connection."
            logger.error("Load Error: \(error.localizedDescription)")
            
            // Save action for the Retry button
            self.lastFailedAction = { await self.loadTrending() }
        }
        isLoading = false
    }

    func retry() {
        Task { await lastFailedAction?() }
    }
}
