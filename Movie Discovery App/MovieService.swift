import Foundation

// Requirement 4.8: Protocol-oriented programming (Interface)
protocol MovieServiceProtocol {
    func fetchTrendingMovies(page: Int) async throws -> MovieResponse
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
}

class MovieService: MovieServiceProtocol {
    // Note: Replace with your actual API Key from TMDB
    private let apiKey = "3b4197393831ce5a7045caf594149bfc"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchTrendingMovies(page: Int) async throws -> MovieResponse {
        let urlString = "\(baseURL)/trending/movie/day?api_key=\(apiKey)&page=\(page)"
        return try await performRequest(url: urlString)
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&page=\(page)"
        return try await performRequest(url: urlString)
    }
    
    private func performRequest(url urlString: String) async throws -> MovieResponse {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        // Requirement 4.8: Concurrency using async/await
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noData }
        
        // Handle HTTP Status Codes
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(MovieResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
