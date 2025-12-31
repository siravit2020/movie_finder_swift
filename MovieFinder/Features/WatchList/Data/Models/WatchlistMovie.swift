//
//  WatchlistMovie.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 9/12/2568 BE.
//

import Foundation
import SwiftData

@Model
final class WatchlistMovie {
    @Attribute(.unique) var id: Int
    var originalLanguage: String
    var originalTitle: String
    var posterURL: URL?
    var title: String
    var voteAverage: Double
    var addedDate: Date

    init(
        id: Int,
        originalLanguage: String,
        originalTitle: String,
        posterURL: URL?,
        title: String,
        voteAverage: Double,
        addedDate: Date,
    ) {
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.posterURL = posterURL
        self.title = title
        self.voteAverage = voteAverage
        self.addedDate = addedDate
    }

    // Convenience initializer จาก Movie entity
    convenience init(from movie: Movie, addedDate: Date = Date.now) {
        self.init(
            id: movie.id,
            originalLanguage: movie.originalLanguage,
            originalTitle: movie.originalTitle,
            posterURL: movie.posterURL,
            title: movie.title,
            voteAverage: movie.voteAverage,
            addedDate: addedDate,
        )
    }

    convenience init(form movieDetail: MovieDetail, addedDate: Date = Date.now)
    {
        self.init(
            id: movieDetail.id,
            originalLanguage: movieDetail.originalLanguage,
            originalTitle: movieDetail.originalTitle,
            posterURL: movieDetail.posterURL,
            title: movieDetail.title,
            voteAverage: movieDetail.voteAverage,
            addedDate: addedDate
        )
    }
}
