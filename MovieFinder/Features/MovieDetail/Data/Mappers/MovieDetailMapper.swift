//
//  MovieDetailMapper.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import Foundation

struct MovieDetailMapper {
    static func map(dto: MovieDetailDTO) -> MovieDetail {
        return MovieDetail(
            adult: dto.adult,
            backdropPath: dto.backdropPath,
            belongsToCollection: dto.belongsToCollection?.toDomain(),
            budget: dto.budget,
            genres: dto.genres.map { $0.toDomain() },
            homepage: dto.homepage,
            id: dto.id,
            imdbID: dto.imdbID,
            originCountry: dto.originCountry,
            originalLanguage: dto.originalLanguage,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            popularity: dto.popularity,
            posterPath: dto.posterPath,
            productionCompanies: dto.productionCompanies.map { $0.toDomain() },
            productionCountries: dto.productionCountries.map { $0.toDomain() },
            releaseDate: dto.releaseDate,
            revenue: dto.revenue,
            runtime: dto.runtime,
            spokenLanguages: dto.spokenLanguages.map { $0.toDomain() },
            status: dto.status,
            tagline: dto.tagline,
            title: dto.title,
            video: dto.video,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount
        )
    }
}

// MARK: - DTO to Domain Extensions
extension BelongsToCollectionDTO {
    func toDomain() -> BelongsToCollection {
        return BelongsToCollection(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }
}

extension GenreDTO {
    func toDomain() -> Genre {
        return Genre(
            id: id,
            name: name
        )
    }
}

extension ProductionCompanyDTO {
    func toDomain() -> ProductionCompany {
        return ProductionCompany(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry
        )
    }
}

extension ProductionCountryDTO {
    func toDomain() -> ProductionCountry {
        return ProductionCountry(
            name: name
        )
    }
}

extension SpokenLanguageDTO {
    func toDomain() -> SpokenLanguage {
        return SpokenLanguage(
            englishName: englishName,
            name: name
        )
    }
}