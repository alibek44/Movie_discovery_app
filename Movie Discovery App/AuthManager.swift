import Foundation
import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    @Published var user: User?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // Add this function below your signOut function
    func signUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        await MainActor.run {
            self.user = result.user
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        await MainActor.run {
            self.user = result.user
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
    }
}
