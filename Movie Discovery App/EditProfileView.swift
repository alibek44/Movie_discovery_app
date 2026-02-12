import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    // Form State
    @State private var displayName: String = ""
    @State private var bio: String = ""
    @State private var favoriteGenre: String = "Action"
    
    // Validation State - Requirement 4.1
    @State private var validationError: String? = nil
    
    let genres = ["Action", "Comedy", "Drama", "Sci-Fi", "Horror"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Public Info")) {
                    TextField("Display Name", text: $displayName)
                    
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .overlay(
                            Group {
                                if bio.isEmpty {
                                    Text("Write a short bio...")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                            }, alignment: .topLeading
                        )
                }
                
                Section(header: Text("Preferences")) {
                    Picker("Favorite Genre", selection: $favoriteGenre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                
                if let error = validationError {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        validateAndSave()
                    }
                }
            }
        }
    }
    
    // Requirement 4.1: User-friendly error messages & validation
    private func validateAndSave() {
        if displayName.trimmingCharacters(in: .whitespaces).count < 3 {
            validationError = "Display name must be at least 3 characters."
        } else if bio.count > 100 {
            validationError = "Bio is too long (max 100 characters)."
        } else {
            validationError = nil
            // Save logic here (e.g., to Firebase or UserDefaults)
            print("Saving Profile: \(displayName)")
            dismiss()
        }
    }
}
