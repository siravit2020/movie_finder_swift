//
//  RemoveFromWatchlistUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

/// Use case for removing a movie from watchlist
@MainActor
final class RemoveFromWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case to remove movie from watchlist
    /// - Parameter id: Movie ID to remove
    /// - Throws: WatchlistError if operation fails
    func execute(id: Int) async throws {
        try await repository.removeFromWatchlist(id: id)
    }
}
