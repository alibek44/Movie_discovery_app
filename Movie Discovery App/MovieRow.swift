import SwiftUI
import Kingfisher

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 15) {
            KFImage(movie.posterURL)
                .resizable()
                .placeholder { Color.gray.opacity(0.2) }
                .onFailureImage(UIImage(named: "placeholder"))
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}
