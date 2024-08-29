//
//  CalendarViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/25/24.
//

import Foundation

final class CalendarViewModel {
    // MARK: - Properties
    private let dateManager = DateManager.shared
    private let bookingManager = BookingManager.shared
    private let networkManager = NetworkManager.shared
    
    @Published var dates: [Date] = []
    @Published var moviesByShowtime: [String: [MovieShowtime]] = [:]
    @Published var movies: [MockMovie] = []
    
    // MARK: - Initialization
    init() {
        fetchDates()
        fetchInitialMovies()
    }
    
    // MARK: - Public Methods
    func fetchDates() {
        dates = dateManager.fetchDates(numberOfDays: 7)
    }
    
    func fetchInitialMovies() {
        Task {
            do {
                let fetchedMovies = try await networkManager.fetchFromMockAPI()
                await MainActor.run {
                    self.movies = fetchedMovies
                    self.groupMoviesByShowtime(fetchedMovies)
                }
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func fetchMoviesForDate(_ date: Date) {
        Task {
            do {
                let fetchedMovies = try await networkManager.fetchFromMockAPI()
                await MainActor.run {
                    self.groupMoviesByShowtime(fetchedMovies)
                }
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func dateSelected(_ date: Date) {
        BookingManager.shared.selectedDate = date
       fetchMoviesForDate(date)
    
    }
    
    func getShowtimeForIndexPath(_ indexPath: IndexPath) -> MovieShowtime? {
        let allShowtimes = moviesByShowtime.values.flatMap { $0 }.sorted { $0.time < $1.time }
        guard indexPath.row < allShowtimes.count else { return nil }
        return allShowtimes[indexPath.row]
    }
    
    // MARK: - Private Methods
    private func groupMoviesByShowtime(_ movies: [MockMovie]) {
        moviesByShowtime.removeAll()
        
        for movie in movies {
            for cinema in movie.availableCinemas {
                for timeSlot in cinema.timeSlots {
                    let showtime = MovieShowtime(
                        time: timeSlot.time,
                        movie: movie,
                        price: timeSlot.price,
                        hall: Int.random(in: 1...5),
                        ageRating: movie.genreIds.contains(28) ? 18 : 12
                    )
                    
                    if moviesByShowtime[timeSlot.time] == nil {
                        moviesByShowtime[timeSlot.time] = [showtime]
                    } else {
                        moviesByShowtime[timeSlot.time]?.append(showtime)
                    }
                }
            }
        }
    }
}
