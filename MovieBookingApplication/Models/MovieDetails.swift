//
//  MovieDetails.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//


import Foundation

struct MovieDetails: Decodable {
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

struct Genre: Decodable {
    let name: String
}
