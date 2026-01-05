//
//  WatchlistDataSource.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation
import SwiftData

@MainActor
protocol WatchlistDataSource {
    func add(_ movie: WatchlistMovie) async throws
    func remove(id: Int) async throws
    func fetch(id: Int) async throws -> WatchlistMovie?
    func fetchAll(sortBy: WatchlistSortOption) async throws -> [WatchlistMovie]
    func exists(id: Int) async -> Bool
    func count() async throws -> Int
}

enum WatchlistSortOption {
    case dateAdded(ascending: Bool)
    case title(ascending: Bool)
    case rating(ascending: Bool)
}

@MainActor
final class WatchlistLocalDataSource: WatchlistDataSource {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func add(_ movie: WatchlistMovie) async throws {
        // Check if already exists
        if await exists(id: movie.id) {
            throw WatchlistError.alreadyExists(id: movie.id)
        }

        do {
            modelContext.insert(movie)
            try modelContext.save()
        } catch {
            throw WatchlistError.databaseError(error)
        }
    }

    func remove(id: Int) async throws {
        let predicate = #Predicate<WatchlistMovie> { $0.id == id }
        let descriptor = FetchDescriptor<WatchlistMovie>(predicate: predicate)

        do {
            guard let movie = try modelContext.fetch(descriptor).first else {
                throw WatchlistError.notFound(id: id)
            }

            modelContext.delete(movie)
            try modelContext.save()
        } catch let error as WatchlistError {
            throw error
        } catch {
            throw WatchlistError.databaseError(error)
        }
    }

    func fetch(id: Int) async throws -> WatchlistMovie? {
        let predicate = #Predicate<WatchlistMovie> { $0.id == id }
        let descriptor = FetchDescriptor<WatchlistMovie>(predicate: predicate)

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            throw WatchlistError.databaseError(error)
        }
    }

    func fetchAll(sortBy: WatchlistSortOption = .dateAdded(ascending: false))
        async throws -> [WatchlistMovie]
    {
        let sortDescriptor: SortDescriptor<WatchlistMovie>

        switch sortBy {
        case .dateAdded(let ascending):
            sortDescriptor = SortDescriptor(
                \.addedDate,
                order: ascending ? .forward : .reverse
            )
        case .title(let ascending):
            sortDescriptor = SortDescriptor(
                \.title,
                order: ascending ? .forward : .reverse
            )
        case .rating(let ascending):
            sortDescriptor = SortDescriptor(
                \.voteAverage,
                order: ascending ? .forward : .reverse
            )
        }

        let descriptor = FetchDescriptor<WatchlistMovie>(sortBy: [
            sortDescriptor
        ])

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            throw WatchlistError.databaseError(error)
        }
    }

    func exists(id: Int) async -> Bool {
        let predicate = #Predicate<WatchlistMovie> { $0.id == id }
        let descriptor = FetchDescriptor<WatchlistMovie>(predicate: predicate)
        return (try? modelContext.fetch(descriptor).first) != nil
    }

    func count() async throws -> Int {
        let descriptor = FetchDescriptor<WatchlistMovie>()

        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            throw WatchlistError.databaseError(error)
        }
    }
}
