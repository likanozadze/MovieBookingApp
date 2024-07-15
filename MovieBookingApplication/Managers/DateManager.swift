//
//  DateManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/15/24.
//

import Foundation


class DateManager {
    static let shared = DateManager()
    
    private let calendar = Calendar.current
    
    private init() {}
    
    func fetchDates(numberOfDays: Int) -> [Date] {
        let today = Date()
        return (0..<numberOfDays).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func shortWeekday(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    func dayOfMonth(from date: Date) -> Int {
        return calendar.component(.day, from: date)
    }
}
