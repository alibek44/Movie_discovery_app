import SwiftUI

struct MainTabView: View {
    @State private var showProfile = false
    @EnvironmentObject var authManager: AuthManager
    // This allows the FavoritesView to see the movies loaded in ContentView
    @StateObject private var movieViewModel = MovieViewModel()
    
    var body: some View {
        NavigationStack {
            TabView {
                ContentView(viewModel: movieViewModel)
                    .tabItem {
                        Label("Trending", systemImage: "flame")
                    }
                
                FavoritesView()
                    .environmentObject(movieViewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .navigationTitle("Movie Discovery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.circle").font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(authManager)
            }
        }
    }
}
