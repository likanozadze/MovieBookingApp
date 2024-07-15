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
        let formattedShowtimes = showtimes.map { DateFormatter.formattedDate(date: $0.startTime, format: "h:mm a") }
        return formattedShowtimes.joined(separator: ", ")
    }
    
    func fetchTimeSlots(for date: Date) -> [TimeSlot] {
        return ShowTime.allCases.map { showTime in
            let ticketPriceCategory: TicketPriceCategory
            switch showTime {
            case .afternoon1: ticketPriceCategory = .afternoon1
            case .afternoon2: ticketPriceCategory = .afternoon2
            case .evening: ticketPriceCategory = .evening
            case .night1: ticketPriceCategory = .night1
            case .night2: ticketPriceCategory = .night2
            }
            let ticketPrices = [TicketPrice(priceCategory: ticketPriceCategory, currency: "USD")]
            return TimeSlot(date: date, showTime: showTime, ticketPrices: ticketPrices)
        }
    }
}
