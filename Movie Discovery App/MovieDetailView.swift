import SwiftUI
import Kingfisher
import FirebaseAuth

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var dbManager = DatabaseManager()
    @EnvironmentObject var authManager: AuthManager
    @State private var newComment = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Movie Poster
                KFImage(movie.posterURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                
                // Title and Favorite Button
                HStack {
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    // --- FAVORITES BUTTON ---
                    Button(action: {
                        if let user = authManager.user {
                            dbManager.toggleFavorite(movieId: movie.id, userId: user.uid)
                        }
                    }) {
                        Image(systemName: dbManager.favoriteMovieIds.contains(movie.id) ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    // ------------------------
                }
                
                Text(movie.overview).font(.body)
                
                Divider()
                
                Text("Comments").font(.headline)
                
                // Requirement 4.6: Realtime List
                ForEach(dbManager.comments) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.userEmail).font(.caption).bold()
                        Text(comment.text).font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
                
                // Requirement 4.1: Form for adding a comment
                HStack {
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Post") {
                        if let user = authManager.user, !newComment.isEmpty {
                            dbManager.addComment(movieId: movie.id,
                                               userId: user.uid,
                                               email: user.email ?? "Anon",
                                               text: newComment)
                            newComment = ""
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // Load comments
            dbManager.observeComments(for: movie.id)
            
            // --- OBSERVE USER FAVORITES ---
            if let user = authManager.user {
                dbManager.observeFavorites(userId: user.uid)
            }
        }
    }
}
