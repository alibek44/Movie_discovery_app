import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Movie Discovery")
                .font(.largeTitle)
                .bold()
            
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Button(action: login) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: register) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
    
    func login() {
        guard validate() else { return }
        print("Attempting Login...")
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            handleAuthResult(result, error)
        }
    }

    func register() {
        guard validate() else { return }
        print("Attempting Registration...")
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            handleAuthResult(result, error)
        }
    }
    
    private func validate() -> Bool {
        if !email.contains("@") || password.count < 6 {
            errorMessage = "Please enter a valid email and 6-character password."
            return false
        }
        errorMessage = ""
        return true
    }
    
    private func handleAuthResult(_ result: AuthDataResult?, _ error: Error?) {
        if let error = error {
            print("Auth Error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        } else {
            print("Auth Success!")
            // Update the EnvironmentObject on the main thread
            DispatchQueue.main.async {
                self.authManager.user = result?.user
            }
        }
    }
}
