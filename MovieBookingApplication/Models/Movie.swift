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

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
