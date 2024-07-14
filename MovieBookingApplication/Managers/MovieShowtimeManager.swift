//
//  MovieShowtimeManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/14/24.
//

import Foundation

final class MovieShowtimeManager {
    // MARK: - Shared Instance
    static let shared = MovieShowtimeManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    // MARK: - Methods
    func currentDayOfWeek() -> String {
        return dayFormatter.string(from: Date()).lowercased()
    }
    
    func getTodaysShowtimes(from movie: Movie) -> String {
        let day = currentDayOfWeek()
        guard let showtimes = movie.showtimes[day] else {
            return "No showtimes available"
        }
        return formatShowtimes(showtimes)
    }
    
    func isMovieShowingNow(from movie: Movie) -> Bool {
        let day = currentDayOfWeek()
        guard let todaysShowtimes = movie.showtimes[day] else {
            return false
        }
        let now = Date()
        
        return todaysShowtimes.contains { timeSlot in
            isNowBetween(startTime: timeSlot.startTime, endTime: timeSlot.endTime, currentDate: now)
        }
    }
    
    private func isNowBetween(startTime: Date, endTime: Date, currentDate: Date) -> Bool {
        return currentDate >= startTime && currentDate <= endTime
    }
    
    private func formatShowtimes(_ showtimes: [TimeSlot]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return showtimes.map { formatter.string(from: $0.startTime) }.joined(separator: ", ")
    }
    

    func setShowtimes(for movie: inout Movie, showtimes: [String: [TimeSlot]]) {
        movie.showtimes = showtimes
    }
}

