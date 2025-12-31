//
//  GetAllWatchlistUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

/// Use case for fetching all movies from watchlist
@MainActor
final class GetAllWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case to get all watchlist movies
    /// - Parameter sortBy: Sort option (default: by date added, newest first)
    /// - Returns: Array of watchlist movies
    /// - Throws: WatchlistError if operation fails
    func execute(sortBy: WatchlistSortOption = .dateAdded(ascending: false)) async throws -> [WatchlistMovie] {
        try await repository.getAllWatchlist(sortBy: sortBy)
    }
}
