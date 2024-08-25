//
//  MovieDetailsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func movieDetailsFetched(_ movie: MockMovie)
    func showError(_ error: Error)
    func movieDetailsImageFetched(_ image: UIImage)
    func timeSlotsFetched(_ timeSlots: [MockTimeSlot])
}

protocol MovieDetailsViewModel {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    func viewDidLoad()
    func fetchTimeSlots(for date: Date)
}

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    private var movieId: Int
    private let networkManager: NetworkManager
  //  private let showtimeManager = MovieShowtimeManager.shared
    weak var delegate: MovieDetailsViewModelDelegate?
    
    init(movieId: Int, networkManager: NetworkManager = NetworkManager.shared) {
            self.movieId = movieId
            self.networkManager = networkManager
        }
    func viewDidLoad() {
        fetchMovieDetails()
    }
    

    private func fetchMovieDetails() {
            Task {
                do {
                    let movies = try await networkManager.fetchFromMockAPI()
                    if let movie = movies.first(where: { $0.id == movieId }) {
                        await MainActor.run {
                            self.delegate?.movieDetailsFetched(movie)
                        }
                        downloadImage(from: movie.posterPath ?? "")
                    } else {
                        throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
                    }
                } catch let error {
                    await MainActor.run {
                        self.delegate?.showError(error)
                    }
                }
            }
        }
    private func downloadImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            self?.delegate?.movieDetailsImageFetched(image ?? UIImage())
        }
    }
    
    func fetchTimeSlots(for date: Date) {
        Task {
            do {
                let movies = try await networkManager.fetchFromMockAPI()
                if let movie = movies.first(where: { $0.id == movieId }) {
                    let timeSlots = movie.availableCinemas.flatMap { $0.timeSlots }
                    delegate?.timeSlotsFetched(timeSlots)
                } else {
                    throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
                }
            } catch let error {
                delegate?.showError(error)
            }
        }
    }
}
