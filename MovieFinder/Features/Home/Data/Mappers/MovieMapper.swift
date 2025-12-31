//
//  MovieMapper.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 6/8/2568 BE.
//

import Foundation

struct MovieMapper {
    static func map(dto: MovieDTO) -> Movie {
        return Movie(
            id: dto.id,
            adult: dto.adult,
            backdropPath: dto.backdropPath,
            genreIds: dto.genreIds,
            originalLanguage: dto.originalLanguage,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            popularity: dto.popularity,
            posterPath: dto.posterPath,
            releaseDate: dto.releaseDate,
            title: dto.title,
            video: dto.video,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount
        )
    }
}
