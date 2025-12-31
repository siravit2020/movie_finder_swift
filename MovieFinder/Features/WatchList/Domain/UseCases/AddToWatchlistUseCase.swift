//
//  AddToWatchlistUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

/// Use case for adding a movie to watchlist
@MainActor
final class AddToWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case to add movie to watchlist
    /// - Parameter movie: Movie to add
    /// - Throws: WatchlistError if operation fails
    func execute(_ movie: MovieDetail) async throws {
        try await repository.addToWatchlist(movie)
    }
}
