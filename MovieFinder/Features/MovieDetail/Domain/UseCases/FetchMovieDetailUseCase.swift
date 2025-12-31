//
//  FetchMovieDetailUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import Foundation

final class FetchMovieDetailUseCase {
    private let repository: MovieDetailRepositoryProtocol

    init(repository: MovieDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int) async throws -> MovieDetail {
        return try await repository.fetchMovieDetail(movieId: movieId)
    }
}
