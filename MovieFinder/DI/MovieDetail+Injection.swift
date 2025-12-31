//
//  MovieDetail+Injection.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import FactoryKit

extension Container {
    var movieDetailRepository: Factory<MovieDetailRepositoryProtocol> {
        self { MovieDetailRepository() }.singleton
    }

    var fetchMovieDetailUseCase: Factory<FetchMovieDetailUseCase> {
        self {
            FetchMovieDetailUseCase(repository: self.movieDetailRepository())
        }
    }

    var fetchMovieVideosUseCase: Factory<FetchMovieVideoUseCase> {
        self {
            FetchMovieVideoUseCase(repository: self.movieDetailRepository())
        }
    }

    var movieDetailViewModel: Factory<MovieDetailViewModel> {
        self {
            @MainActor in
            MovieDetailViewModel(
                fetchMovieDetailUseCase: self.fetchMovieDetailUseCase(),
                fetchMovieVideosUseCase: self.fetchMovieVideosUseCase(),
                addToWatchlistUseCase: self.addToWatchlistUseCase(),
                removeFromWatchlistUseCase: self.removeFromWatchlistUseCase(),
                checkWatchlistStatusUseCase: self.checkWatchlistStatusUseCase()
            )
        }
    }
}
