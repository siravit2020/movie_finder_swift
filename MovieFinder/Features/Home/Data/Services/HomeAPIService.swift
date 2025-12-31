//
//  HomeAPIService.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 19/7/2568 BE.
//

import Foundation

protocol HomeAPIServiceProtocol {
    func fetchNowShowingMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    func fetchPopularMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    func fetchTopRatedMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    func fetchUpcomingMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
}

final class HomeAPIService: HomeAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    private let baseURL: String

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        self.baseURL = AppConfig.apiBaseURL
    }

    func fetchNowShowingMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    {
        let endpoint = baseURL + "movie/now_playing"

        let result: MovieResponseDTO = try await apiService.get(
            from: endpoint,
            params: params
        )
        return result

    }

    func fetchPopularMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    {
        let endpoint = baseURL + "movie/popular"

        return try await apiService.get(
            from: endpoint,
            params: params
        )
    }

    func fetchTopRatedMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    {
        let endpoint = baseURL + "movie/top_rated"

        return try await apiService.get(
            from: endpoint,
            params: params
        )
    }

    func fetchUpcomingMovies(params: MovieRequestParams?) async throws
        -> MovieResponseDTO
    {
        let endpoint = baseURL + "movie/upcoming"

        return try await apiService.get(
            from: endpoint,
            params: params
        )
    }
}
