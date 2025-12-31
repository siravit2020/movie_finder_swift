//
//  MovieDetailViewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCase
    private let fetchMovieVideosUseCase: FetchMovieVideoUseCase
    private let addToWatchlistUseCase: AddToWatchlistUseCase
    private let removeFromWatchlistUseCase: RemoveFromWatchlistUseCase
    private var checkWatchlistStatusUseCase: CheckWatchlistStatusUseCase

    @Published var movieDetail: MovieDetail? = nil
    @Published var movieVideo: VideoResponse? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isInWatchlist = false

    init(
        fetchMovieDetailUseCase: FetchMovieDetailUseCase,
        fetchMovieVideosUseCase: FetchMovieVideoUseCase,
        addToWatchlistUseCase: AddToWatchlistUseCase,
        removeFromWatchlistUseCase: RemoveFromWatchlistUseCase,
        checkWatchlistStatusUseCase: CheckWatchlistStatusUseCase
    ) {
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
        self.fetchMovieVideosUseCase = fetchMovieVideosUseCase
        self.addToWatchlistUseCase = addToWatchlistUseCase
        self.removeFromWatchlistUseCase = removeFromWatchlistUseCase
        self.checkWatchlistStatusUseCase = checkWatchlistStatusUseCase
    }

    func initialize(movieId: Int) async {
        await fetchMovieDetail(movieId: movieId)
        await checkWatchlistStatus(movieId: movieId)
    }

    func fetchMovieDetail(movieId: Int) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let movie = fetchMovieDetailUseCase.execute(
                movieId: movieId
            )
            async let videos = fetchMovieVideosUseCase.execute(
                movieId: movieId
            )
            let (movieDetail, videoResponse) = try await (movie, videos)
            self.movieDetail = movieDetail
            self.movieVideo = videoResponse
        } catch {
            print("Error fetching movie detail: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }

    func checkWatchlistStatus(movieId: Int) async {
        let status = await checkWatchlistStatusUseCase.execute(
            id: movieId
        )
        self.isInWatchlist = status
    }

    func addToWatchlist(movie: MovieDetail) async {
        do {
            try await addToWatchlistUseCase.execute(movie)
            await checkWatchlistStatus(movieId: movie.id)
        } catch {
            print("Error adding to watchlist: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }

    func removeFromWatchlist(movie: MovieDetail) async {
        do {
            try await removeFromWatchlistUseCase.execute(id: movie.id)
            await checkWatchlistStatus(movieId: movie.id)
        } catch {
            print("Error removing from watchlist: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }
}
