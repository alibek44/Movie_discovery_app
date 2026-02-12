import XCTest
@testable import Movie_Discovery_App

class CacheLogicTests: XCTestCase {
    func testMovieModelDecoding() {
        let json = """
        {
            "id": 1,
            "title": "Inception",
            "overview": "A thief who steals corporate secrets...",
            "poster_path": "/path.jpg",
            "vote_average": 8.8
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        XCTAssertNoThrow(try decoder.decode(Movie.self, from: json))
    }
}
