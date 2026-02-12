import Foundation
import CoreData

protocol MovieRepositoryProtocol {
    func getTrendingMovies(page: Int) async throws -> [Movie]
}

class MovieRepository: MovieRepositoryProtocol {
    // FIX: Static shared instance for ViewModel access
    static let shared = MovieRepository()
    
    private let service: MovieServiceProtocol
    private let context: NSManagedObjectContext
    
    init(service: MovieServiceProtocol = MovieService(),
         context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.service = service
        self.context = context
    }
    
    func getTrendingMovies(page: Int) async throws -> [Movie] {
        do {
            let response = try await service.fetchTrendingMovies(page: page)
            let movies = response.results
            
            // Sync strategy (Requirement 3.3 Performance improvement: Caching)
            await saveToCache(movies: movies)
            return movies
        } catch {
            // Requirement 3.2: Error Handling - Fallback to Local Cache
            print("Network failed, fetching from local cache: \(error.localizedDescription)")
            return fetchLocalMovies()
        }
    }
    
    private func saveToCache(movies: [Movie]) async {
        await context.perform {
            for movie in movies {
                let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
                
                let entity = (try? self.context.fetch(fetchRequest).first) ?? MovieEntity(context: self.context)
                
                entity.id = Int64(movie.id)
                entity.title = movie.title
                entity.overview = movie.overview
                entity.posterPath = movie.posterPath
                entity.voteAverage = movie.voteAverage
                entity.timestamp = Date()
            }
            try? self.context.save()
        }
    }

    private func fetchLocalMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MovieEntity.timestamp, ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.map { entity in
                // FIX: Added missing releaseDate parameter to resolve compiler error
                Movie(id: Int(entity.id),
                      title: entity.title ?? "Unknown",
                      overview: entity.overview ?? "",
                      posterPath: entity.posterPath,
                      releaseDate: nil,
                      voteAverage: entity.voteAverage)
            }
        } catch {
            return []
        }
    }
}
