//
//  CheckWatchlistStatusUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

/// Use case for checking if a movie is in watchlist
@MainActor
final class CheckWatchlistStatusUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case to check if movie is in watchlist
    /// - Parameter id: Movie ID to check
    /// - Returns: True if movie exists in watchlist
    func execute(id: Int) async -> Bool {
        await repository.isInWatchlist(id: id)
    }
}
