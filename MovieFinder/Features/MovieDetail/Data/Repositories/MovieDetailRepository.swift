//
//  MovieDetailRepository.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import Foundation

class MockMovieDetailRepository: MovieDetailRepositoryProtocol {
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        let movieDetailDTO: MovieDetailDTO = loadJson("testMovieDetail.json")
        return MovieDetailMapper.map(dto: movieDetailDTO)
    }

    func fetchMovieVideos(movieId: Int) async throws -> VideoResponse {
        let videoResponseDTO: VideoResponseDTO = loadJson("testMovieDetailVideo.json")
        return VideoMapper.map(dto: videoResponseDTO)
    }
}

class MovieDetailRepository: MovieDetailRepositoryProtocol {
    private let apiService: MovieDetailAPIServiceProtocol

    init(apiService: MovieDetailAPIServiceProtocol = MovieDetailAPIService()) {
        self.apiService = apiService
    }

    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        return try await apiService.fetchMovieDetail(movieId: movieId)
    }
    
    func fetchMovieVideos(movieId: Int) async throws -> VideoResponse {
        return try await apiService.fetchMovieVideos(movieId: movieId)
    }
}
