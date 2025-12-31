//
//  GetWatchlistCountUseCase.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

/// Use case for getting the count of movies in watchlist
@MainActor
final class GetWatchlistCountUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case to get watchlist count
    /// - Returns: Number of movies in watchlist
    /// - Throws: WatchlistError if operation fails
    func execute() async throws -> Int {
        try await repository.getWatchlistCount()
    }
}
