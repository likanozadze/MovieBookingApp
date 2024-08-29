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
    
    private(set) var allMovies: [MockMovie] = []
    private var upcomingMovies: [MockMovie] = []
    
    weak var delegate: MoviesListViewModelDelegate?
    
    func viewDidLoad() {
        fetchMovies()
        fetchUpcomingMovies()
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        let movieId = allMovies[indexPath.row].id
        delegate?.navigateToMovieDetails(with: movieId)
    }
    
    func didSelectUpcomingMovie(at indexPath: IndexPath) {
        let movieId = upcomingMovies[indexPath.row].id
        delegate?.navigateToUpcomingMovieDetails(with: movieId)
    }
    
    func fetchMovies() {
        Task {
            do {
                let movies = try await NetworkManager.shared.fetchFromMockAPI()
                self.allMovies = movies
                DispatchQueue.main.async {
                    self.delegate?.moviesFetched(movies)
                }
            } catch {
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
                DispatchQueue.main.async {
                    self.delegate?.upcomingMoviesFetched(movies)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.showError(error)
                }
            }
        }
    }
    
    func getMovies(for cinemaId: String) -> [MockMovie] {
        let filteredMovies = allMovies.filter { movie in
            movie.availableCinemas.contains { cinema in
                cinema.cinemaId == cinemaId
            }
        }
        return filteredMovies
    }
}
