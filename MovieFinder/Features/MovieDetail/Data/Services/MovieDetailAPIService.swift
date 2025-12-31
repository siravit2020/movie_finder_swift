//
//  MovieDetailAPIService.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import Foundation

protocol MovieDetailAPIServiceProtocol {
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail
    func fetchMovieVideos(movieId: Int) async throws -> VideoResponse
}

final class MovieDetailAPIService: MovieDetailAPIServiceProtocol {
    private let apiService: APIServiceProtocol
    private let baseURL: String

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        self.baseURL = AppConfig.apiBaseURL
    }

    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        let endpoint = baseURL + "movie/\(movieId)"

        let dto: MovieDetailDTO = try await apiService.get(
            from: endpoint,
            params: nil as String?
        )
        return MovieDetailMapper.map(dto: dto)
    }
    
    func fetchMovieVideos(movieId: Int) async throws -> VideoResponse {
        let endpoint = baseURL + "movie/\(movieId)/videos"
        
        let dto: VideoResponseDTO = try await apiService.get(
            from: endpoint,
            params: nil as String?
        )
        
        return VideoMapper.map(dto: dto)
    }
}
