//
//  Movies.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 10/03/22.
//
// swiftlint:disable identifier_name

import Foundation

struct MovieResponse: Codable {
    let results: [Movies]
}

struct Movies: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
