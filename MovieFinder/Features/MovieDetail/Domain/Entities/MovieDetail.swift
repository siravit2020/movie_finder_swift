//
//  MovieDetail.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import Foundation

struct MovieDetail: Identifiable, DateFormattable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    var duration: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)mis"
        } else {
            return "\(minutes)mis"
        }
    }

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let baseImageURL = AppConfig.apiBaseImageURL
        return URL(string: baseImageURL + "w500" + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let baseImageURL = AppConfig.apiBaseImageURL
        return URL(string: baseImageURL + "original" + backdropPath)
    }
}

// MARK: - Supporting Types
struct BelongsToCollection: Identifiable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
}

struct Genre: Identifiable {
    let id: Int
    let name: String
}

struct ProductionCompany: Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry {
    let name: String
}

struct SpokenLanguage {
    let englishName: String
    let name: String
}
