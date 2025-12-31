//
//  PopularMoviesViewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import Foundation

@MainActor
class PopularMoviesViewModel: BaseMovieListViewModel {
    private let fetchPopular: FetchPopularMoviesUseCase

    init(fetchPopular: FetchPopularMoviesUseCase) {
        self.fetchPopular = fetchPopular
    }

    override func executeUseCase(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        return try await fetchPopular.execute(
            params: params
        )
    }

}
