//
//  HomeViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    func moviesFetched(_ movies: [Movie])
    func upcomingMoviesFetched(_ movies: [Movie])
    func showError(_ error: Error)
    func navigateToMovieDetails(with movieId: Int)
    func navigateToUpcomingMovieDetails(with movieId: Int)
}

final class HomeViewModel {
    private var movies: [Movie]?
    private var upcomingMovies: [Movie]?
    
    weak var delegate: MoviesListViewModelDelegate?
    
    func viewDidLoad() {
        fetchMovies()
        fetchUpcomingMovies()
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        if let movieId = movies?[indexPath.row].id {
            delegate?.navigateToMovieDetails(with: movieId)
        }
    }
    
    func didSelectUpcomingMovie(at indexPath: IndexPath) {
        if let selectedMovie = upcomingMovies?[indexPath.row] {
            delegate?.navigateToUpcomingMovieDetails(with: selectedMovie.id)
        }
    }

    private func fetchMovies() {
        NetworkManager.shared.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.delegate?.moviesFetched(movies)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    private func fetchUpcomingMovies() {
        NetworkManager.shared.fetchUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.upcomingMovies = movies
                self?.delegate?.upcomingMoviesFetched(movies)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
