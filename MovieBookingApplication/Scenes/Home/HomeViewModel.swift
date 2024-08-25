//
//  HomeViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    func moviesFetched(_ movies: [MockMovie])
    func upcomingMoviesFetched(_ movies: [MockMovie])
    func showError(_ error: Error)
    func navigateToMovieDetails(with movieId: Int)
    func navigateToUpcomingMovieDetails(with movieId: Int)
}

final class HomeViewModel {
    
    private var movies: [MockMovie]?
    private var upcomingMovies: [MockMovie]?
    
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
    
    func fetchMovies() {
        Task {
            do {
                let movies = try await NetworkManager.shared.fetchFromMockAPI()
                self.movies = movies
                DispatchQueue.main.async {
                    self.delegate?.moviesFetched(movies)
                }
            } catch let error as NSError {
                if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? Error {
                }
                DispatchQueue.main.async {
                    self.delegate?.showError(error)
                }
            }
        }
    }

    private func fetchUpcomingMovies() {
        Task {
            do {
                let movies = try await NetworkManager.shared.fetchUpcomingMoviesFromMockAPI()
                self.upcomingMovies = movies
                self.delegate?.upcomingMoviesFetched(movies)
            } catch {
                self.delegate?.showError(error)
            }
        }
    }
}
