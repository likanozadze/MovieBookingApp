//
//  UpcomingMoviesDetailsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/25/24.
//
//
import UIKit
import Foundation


protocol UpcomingMoviesDetailsViewModelDelegate: AnyObject {
    func moviesDetailsFetched(_ movie: MockMovie)
    func showError(_ error: Error)
    func movieImageFetched(_ image: UIImage)
}

protocol UpcomingMoviesDetailsViewModel {
    var delegate: UpcomingMoviesDetailsViewModelDelegate? { get set }
    func viewDidLoad()
    func fetchMovieDetails()
}

class DefaultUpcomingMoviesDetailsViewModel: UpcomingMoviesDetailsViewModel {
    private let movieId: Int
    private let networkManager: NetworkManager
    weak var delegate: UpcomingMoviesDetailsViewModelDelegate?
    
    init(movieId: Int, networkManager: NetworkManager = NetworkManager.shared) {
        self.movieId = movieId
        self.networkManager = networkManager
    }
    
    func viewDidLoad() {
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        Task {
            do {
                let movies = try await networkManager.fetchUpcomingMoviesFromMockAPI()
                if let movie = movies.first(where: { $0.id == movieId }) {
                    await MainActor.run {
                        self.delegate?.moviesDetailsFetched(movie)
                    }
                    if let posterPath = movie.posterPath {
                        downloadImage(from: posterPath)
                    }
                } else {
                    throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
                }
            } catch {
                await MainActor.run {
                    self.delegate?.showError(error)
                }
            }
        }
    }
    
    private func downloadImage(from url: String) {
        networkManager.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.delegate?.movieImageFetched(image ?? UIImage())
            }
        }
    }
}
