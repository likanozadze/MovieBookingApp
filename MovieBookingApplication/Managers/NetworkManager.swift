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
    func fetchFromMockAPI() async throws -> [MockMovie] {
        let urlStr = Constants.URLs.moviesListURL
        
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
        let urlStr = Constants.URLs.upcomingMoviesURL
        
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
