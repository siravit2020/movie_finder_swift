//
//  MovieResponseMapper.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 8/8/2568 BE.
//

import Foundation

struct MovieResponseMapper {
    static func map(dto: MovieResponseDTO) -> MovieResponse {
        return MovieResponse(
            dates: dto.dates.map { dateRange in
                MovieResponse.DateRange(
                    maximum: dateRange.maximum,
                    minimum: dateRange.minimum
                )
            },
            page: dto.page,
            results: dto.results.map(MovieMapper.map),
            totalPages: dto.totalPages,
            totalResults: dto.totalResults
        )
    }
}
