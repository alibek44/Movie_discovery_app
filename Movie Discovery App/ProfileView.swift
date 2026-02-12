import SwiftUI
import FirebaseAuth


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    // MOVE STATE HERE: This is the correct "non-local scope"
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account Information")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(authManager.user?.email ?? "Not logged in")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("User ID")
                        Spacer()
                        Text(authManager.user?.uid.prefix(8) ?? "")
                            .foregroundColor(.gray)
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                
                Section {
                    // Added Edit Profile button inside the List for better UI
                    Button(action: {
                        showEditSheet = true
                    }) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    
                    Button(action: {
                        do {
                            try authManager.signOut()
                        } catch {
                            print("Error signing out")
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            // MODIFIERS HERE: Sheets should be attached to the outermost view in the body
            .sheet(isPresented: $showEditSheet) {
                EditProfileView()
            }
        }
    }
}
