//
//  MovieDetailsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func movieDetailsFetched(_ movie: MovieDetails)
    func showError(_ error: Error)
    func movieDetailsImageFetched(_ image: UIImage)
}

protocol MovieDetailsViewModel {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    private var movieId: Int
    
    weak var delegate: MovieDetailsViewModelDelegate?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func viewDidLoad() {
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        Task {
            do {
                let movieDetails = try await NetworkManager.shared.fetchMovieDetails(for: movieId)
                delegate?.movieDetailsFetched(movieDetails)
                downloadImage(from: movieDetails.posterPath)
            } catch let error {
                delegate?.showError(error)
            }
        }
    }
    
    private func downloadImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            self?.delegate?.movieDetailsImageFetched(image ?? UIImage())
        }
    }
}

