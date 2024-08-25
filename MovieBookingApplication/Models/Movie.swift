//
//  Movie.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//


import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [MockMovie]
}

struct MockMovie: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let availableCinemas: [Cinema]
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case availableCinemas = "available_cinemas"
    }

    var genres: [GenreName] {
        genreIds.compactMap { GenreName(rawValue: $0) }
    }
}

struct Cinema: Decodable {
    let cinemaId: String
    let cinemaName: String
    let timeSlots: [MockTimeSlot]
    
    enum CodingKeys: String, CodingKey {
        case cinemaId = "cinema_id"
        case cinemaName = "cinema_name"
        case timeSlots = "time_slots"
    }
}

enum GenreName: Int, CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case drama = 18
   
    var description: String {
        switch self {
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .drama: return "Drama"
        }
    }
}
struct MovieShowtime {
    let time: String
    let movie: MockMovie
    let price: Double
    let hall: Int
    let ageRating: Int
}
