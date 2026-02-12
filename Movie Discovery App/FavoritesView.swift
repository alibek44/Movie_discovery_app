import SwiftUI
import FirebaseAuth // Required to fix the 'uid' error

struct FavoritesView: View {
    @StateObject private var dbManager = DatabaseManager()
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        List {
            let favMovies = movieViewModel.movies.filter { movie in
                dbManager.favoriteMovieIds.contains(movie.id)
            }
            
            if favMovies.isEmpty {
                Text("No favorites yet. Go heart some movies!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(favMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRow(movie: movie)
                    }
                }
            }
        }
        .onAppear {
            if let userId = authManager.user?.uid {
                dbManager.observeFavorites(userId: userId)
            }
        }
    }
}
