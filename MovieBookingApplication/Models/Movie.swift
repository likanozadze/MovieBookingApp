//
//  Movie.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String
    let voteAverage: Double
    let genres: [Genre]
    var showtimes: [String: [TimeSlot]] = [:]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        
      
        let genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.genres = genreIds.map { id in
            Genre(name: GenreName.from(id: id))
        }
        
        self.showtimes = [:]
    }
    
    struct Genre: Decodable {
        let name: String
    }
}

enum GenreName: Int, CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case drama = 18
  
    
    static func from(id: Int) -> String {
        if let genre = GenreName(rawValue: id) {
            return "\(genre)".capitalized
        } else {
            return "Unknown"
        }
    }
}
