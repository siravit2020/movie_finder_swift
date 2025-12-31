//
//  FetchPopularMoviesUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 11/8/2568 BE.
//

import Foundation

class FetchPopularMoviesUseCase {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: MovieRequestParams) async throws -> MovieResponse {
        return try await repository.fetchPopularMovies(
            params: params
        )
    }
}
