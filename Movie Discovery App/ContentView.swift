import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel() // Use StateObject for ownership
    
    var body: some View {
        NavigationStack { // Wrap in NavigationStack for the links to work
            VStack(spacing: 0) {
                // Search Bar
                TextField("Search movies...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Group {
                    if let error = viewModel.errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.icloud")
                                .font(.system(size: 60))
                                .foregroundColor(.red)
                            Text(error)
                                .font(.headline)
                            Button(action: { viewModel.retry() }) {
                                Label("Retry", systemImage: "arrow.clockwise")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if viewModel.isLoading && viewModel.movies.isEmpty {
                        ProgressView("Loading Fresh Movies...")
                    } else if viewModel.movies.isEmpty {
                        ContentUnavailableView("No Movies Found", systemImage: "film")
                            .onTapGesture {
                                Task { await viewModel.loadTrending() }
                            }
                    } else {
                        List(viewModel.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.loadTrending()
                        }
                    }
                }
            }
            .navigationTitle("Trending Now")
            // CRITICAL FIX: Trigger the initial data load
            .task {
                await viewModel.loadTrending()
            }
        }
    }
}
