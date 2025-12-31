//
//  NowShowingMoviesViewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import Foundation

@MainActor
class NowShowingMoviesViewModel: BaseMovieListViewModel {
    private let fetchNowShowing: FetchNowShowingMoviesUseCase

    init(fetchNowShowing: FetchNowShowingMoviesUseCase) {
        self.fetchNowShowing = fetchNowShowing
    }

    override func executeUseCase(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        return try await fetchNowShowing.execute(
            params: params
        )
    }

}
