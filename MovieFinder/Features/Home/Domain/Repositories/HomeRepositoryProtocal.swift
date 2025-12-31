//
//  HomeRepository.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 31/7/2568 BE.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchNowShowingMovies(params: MovieRequestParams) async throws
        -> MovieResponse

    func fetchPopularMovies(params: MovieRequestParams) async throws
        -> MovieResponse
}
