//
//  WatchlistRepository.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 9/12/2568 BE.
//

import Foundation
import SwiftData

protocol WatchlistRepositoryProtocol {
    func addToWatchlist(_ movie: MovieDetail) async throws
    func removeFromWatchlist(id: Int) async throws
    func isInWatchlist(id: Int) async -> Bool
    func getAllWatchlist(sortBy: WatchlistSortOption) async throws
        -> [WatchlistMovie]
    func getWatchlistMovie(id: Int) async throws -> WatchlistMovie
    func getWatchlistCount() async throws -> Int
}

extension WatchlistRepositoryProtocol {
    func getAllWatchlist(
        sortBy: WatchlistSortOption = .dateAdded(ascending: false)
    ) async throws -> [WatchlistMovie] {
        try await getAllWatchlist(sortBy: sortBy)
    }
}

@MainActor
final class WatchlistRepository: WatchlistRepositoryProtocol {
    private let dataSource: WatchlistDataSource

    init(dataSource: WatchlistDataSource) {
        self.dataSource = dataSource
    }

    /// Add movie to watchlist
    /// - Parameter movie: Movie to add
    /// - Throws: WatchlistError if operation fails
    func addToWatchlist(_ movie: MovieDetail) async throws {
        // Validate movie data
        guard !movie.title.isEmpty else {
            throw WatchlistError.invalidData
        }

        // Check if already exists
        if await dataSource.exists(id: movie.id) {
            throw WatchlistError.alreadyExists(id: movie.id)
        }

        // Convert to watchlist model
        let watchlistMovie = WatchlistMovie(form: movie)

        // Add to data source
        try await dataSource.add(watchlistMovie)
    }

    /// Remove movie from watchlist
    /// - Parameter id: Movie ID to remove
    /// - Throws: WatchlistError if movie not found or operation fails
    func removeFromWatchlist(id: Int) async throws {
        try await dataSource.remove(id: id)
    }

    /// Check if movie is in watchlist
    /// - Parameter id: Movie ID to check
    /// - Returns: True if movie exists in watchlist
    func isInWatchlist(id: Int) async -> Bool {
        await dataSource.exists(id: id)
    }

    /// Get all movies from watchlist
    /// - Parameter sortBy: Sort option (default: by date added, newest first)
    /// - Returns: Array of watchlist movies
    /// - Throws: WatchlistError if operation fails
    func getAllWatchlist(
        sortBy: WatchlistSortOption = .dateAdded(ascending: false)
    ) async throws -> [WatchlistMovie] {
        try await dataSource.fetchAll(sortBy: sortBy)
    }

    /// Get specific movie from watchlist
    /// - Parameter id: Movie ID to fetch
    /// - Returns: WatchlistMovie if found
    /// - Throws: WatchlistError if not found or operation fails
    func getWatchlistMovie(id: Int) async throws -> WatchlistMovie {
        guard let movie = try await dataSource.fetch(id: id) else {
            throw WatchlistError.notFound(id: id)
        }
        return movie
    }

    /// Get watchlist count
    /// - Returns: Number of movies in watchlist
    /// - Throws: WatchlistError if operation fails
    func getWatchlistCount() async throws -> Int {
        try await dataSource.count()
    }
}
