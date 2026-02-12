import Foundation
import FirebaseDatabase
import Combine

// Ensure it conforms to ObservableObject so @StateObject works
class DatabaseManager: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var favoriteMovieIds: Set<Int> = []
    
    private let ref = Database.database().reference()
    
    // --- FAVORITES LOGIC ---
    func toggleFavorite(movieId: Int, userId: String) {
        let favRef = ref.child("users").child(userId).child("favorites").child("\(movieId)")
        
        if favoriteMovieIds.contains(movieId) {
            favRef.removeValue()
        } else {
            // Requirement 4.1: Persist favorite status
            favRef.setValue(true)
        }
    }

    func observeFavorites(userId: String) {
        ref.child("users").child(userId).child("favorites").observe(.value) { snapshot in
            var ids = Set<Int>()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot, let id = Int(snap.key) {
                    ids.insert(id)
                }
            }
            DispatchQueue.main.async {
                self.favoriteMovieIds = ids
            }
        }
    }

    // --- COMMENTS LOGIC ---
    func observeComments(for movieId: Int) {
        ref.child("comments").child("\(movieId)").observe(.value) { snapshot in
            var newComments: [Comment] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    // FIX: Included missing parameters to resolve compiler error
                    let comment = Comment(
                        id: snap.key,
                        userId: dict["userId"] as? String ?? "",
                        userEmail: dict["email"] as? String ?? "Anonymous",
                        text: dict["text"] as? String ?? "",
                        timestamp: dict["timestamp"] as? Double ?? 0.0
                    )
                    newComments.append(comment)
                }
            }
            DispatchQueue.main.async {
                self.comments = newComments
            }
        }
    }
    
    func addComment(movieId: Int, userId: String, email: String, text: String) {
        let data: [String: Any] = [
            "userId": userId,
            "email": email,
            "text": text,
            "timestamp": ServerValue.timestamp()
        ]
        ref.child("comments").child("\(movieId)").childByAutoId().setValue(data)
    }
}
