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
    
    func getTodaysShowtimes(from movie: MockMovie) -> String {
        let allShowtimes = movie.availableCinemas.flatMap { $0.timeSlots }
        return formatShowtimes(allShowtimes)
    }
    
    func isMovieShowingNow(from movie: MockMovie) -> Bool {
        let now = Date()
        return movie.availableCinemas.contains { cinema in
            cinema.timeSlots.contains { timeSlot in
                isNowBetween(timeString: timeSlot.time, currentDate: now)
            }
        }
    }
    
    private func isNowBetween(timeString: String, currentDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let time = formatter.date(from: timeString) else {
            return false
        }
        
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: currentDate) + time.timeIntervalSinceReferenceDate
        let endTime = startTime + 3600
        
        return currentDate >= startTime && currentDate <= endTime
    }
    
    private func formatShowtimes(_ showtimes: [MockTimeSlot]) -> String {
        return showtimes.map { $0.time }.joined(separator: ", ")
    }
}
