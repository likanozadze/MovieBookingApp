//
//  NetworkManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}

// MARK: - Fetch Movie Details

extension NetworkManager {
    func fetchMovieDetails(for id: Int) async throws -> MovieDetails {
        let urlStr = "https://mocki.io/v1/8bcef72b-a930-4e29-962c-16686fa3d0a9"
        
        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                
                let movieDetailsList = try JSONDecoder().decode([MovieDetails].self, from: data)
                if let movieDetail = movieDetailsList.first(where: { $0.id == id }) {
                    return movieDetail
                } else {
                    throw NSError(domain: "com.yourdomain.app", code: -4, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
                }
            } catch {
                throw NSError(domain: "com.yourdomain.app", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
            }
        } catch {
            throw NSError(domain: "com.yourdomain.app", code: -3, userInfo: [NSLocalizedDescriptionKey: "Network request failed: \(error.localizedDescription)"])
        }
    }
}

// MARK: - Fetch from Mock API

extension NetworkManager {
    func fetchFromMockAPI() async throws -> [MockMovie] {
        let urlStr = "https://mocki.io/v1/8bcef72b-a930-4e29-962c-16686fa3d0a9"
        
        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data: \(error.localizedDescription)"])
        }
    }
}

extension NetworkManager {
    func fetchUpcomingMoviesFromMockAPI() async throws -> [MockMovie] {
        let urlStr = "https://mocki.io/v1/e5f56879-fcb6-4eb4-87e1-9a0b81ab284d"
        
        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            
            let dataString = String(data: data, encoding: .utf8)
            print("Raw Response Data: \(dataString ?? "No Data")")
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data: \(error.localizedDescription)"])
        }
    }
}
