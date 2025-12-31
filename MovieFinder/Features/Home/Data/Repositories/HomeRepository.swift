//
//  HomeRepository.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 31/7/2568 BE.
//

import Foundation

class MockHomeRepository: HomeRepositoryProtocol {
    func fetchNowShowingMovies(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        let response: MovieResponseDTO = loadJson("testMovieList.json")
        return MovieResponseMapper.map(dto: response)
    }

    func fetchPopularMovies(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        let response: MovieResponseDTO = loadJson("testMovieList.json")
        return MovieResponseMapper.map(dto: response)
    }

}

class HomeRepository: HomeRepositoryProtocol {
    private let apiService: HomeAPIServiceProtocol
    private let baseURL: String

    init(apiService: HomeAPIServiceProtocol = HomeAPIService()) {
        self.apiService = apiService
        self.baseURL = AppConfig.apiBaseURL
    }

    func fetchNowShowingMovies(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        let response: MovieResponseDTO =
            try await apiService.fetchNowShowingMovies(params: params)
        return MovieResponseMapper.map(dto: response)
    }

    func fetchPopularMovies(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        let response: MovieResponseDTO =
            try await apiService.fetchPopularMovies(params: params)
        return MovieResponseMapper.map(dto: response)
    }

}
