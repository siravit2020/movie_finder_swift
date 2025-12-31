//
//  MovieDetailRepositoryProtocol.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 3/9/2568 BE.
//

import Foundation

protocol MovieDetailRepositoryProtocol {
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail
    func fetchMovieVideos(movieId: Int) async throws -> VideoResponse
}
