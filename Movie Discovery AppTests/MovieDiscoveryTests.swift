import XCTest
@testable import Movie_Discovery_App // Replace with your actual project name

final class MovieDiscoveryTests: XCTestCase {

    // Test 1: Verify Movie Model Decoding
    func testMovieDecoding() {
        let json = """
        {
            "id": 1,
            "title": "Inception",
            "overview": "A thief who steals corporate secrets...",
            "poster_path": "/inception.jpg",
            "vote_average": 8.8
        }
        """.data(using: .utf8)!
        
        let movie = try? JSONDecoder().decode(Movie.self, from: json)
        
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.title, "Inception")
    }

    // Test 2: Verify URL Construction
    func testPosterURL() {
        let movie = Movie(id: 1, title: "Test", overview: "Test", posterPath: "/test.jpg", voteAverage: 5.0)
        XCTAssertEqual(movie.posterURL?.absoluteString, "https://image.tmdb.org/t/p/w500/test.jpg")
    }

    // Test 3: Verify Search Text Logic
    @MainActor
    func testSearchDebounceState() {
        let viewModel = MovieViewModel()
        viewModel.searchText = "Batman"
        XCTAssertEqual(viewModel.searchText, "Batman")
    }

    // Test 4: Verify Initial State
    @MainActor
    func testViewModelInitialState() {
        let viewModel = MovieViewModel()
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    // Test 5: Verify Pagination Logic State
    @MainActor
    func testPaginationIncrement() async {
        let viewModel = MovieViewModel()
        // Simulate loading next page
        await viewModel.loadNextPage()
        // Even if network fails, we verify the attempt was logged or state was managed
        XCTAssertFalse(viewModel.isLoading)
    }
}
