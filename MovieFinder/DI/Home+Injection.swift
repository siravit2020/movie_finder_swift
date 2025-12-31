//
//  Home+Injection.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 11/8/2568 BE.
//

import FactoryKit

extension Container {
    var movieRepository: Factory<HomeRepositoryProtocol> {
        self { HomeRepository() }.singleton
    }

    var fetchNowShowingUseCase: Factory<FetchNowShowingMoviesUseCase> {
        self {
            FetchNowShowingMoviesUseCase(repository: self.movieRepository())
        }
    }

    var fetchPopularUseCase: Factory<FetchPopularMoviesUseCase> {
        self { FetchPopularMoviesUseCase(repository: self.movieRepository()) }
    }

    var homeViewModel: Factory<HomeViewModel> {
        self {
            @MainActor in
            HomeViewModel(
                fetchNowShowing: self.fetchNowShowingUseCase(),
                fetchPopular: self.fetchPopularUseCase()
            )
        }
    }

    var nowShowingMoviesViewModel: Factory<NowShowingMoviesViewModel> {
        self {
            @MainActor in
            NowShowingMoviesViewModel(
                fetchNowShowing: self.fetchNowShowingUseCase(),
            )
        }
    }
    var popularMoviesViewModel: Factory<PopularMoviesViewModel> {
        self {
            @MainActor in
            PopularMoviesViewModel(
                fetchPopular: self.fetchPopularUseCase()
            )
        }
    }
}
