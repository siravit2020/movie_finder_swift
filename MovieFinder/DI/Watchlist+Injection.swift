//
//  Watchlist+Injection.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import FactoryKit
import SwiftData

extension Container {
    // MARK: - Data Source
    var watchlistDataSource: Factory<WatchlistDataSource> {
        self {
            @MainActor in
            WatchlistLocalDataSource(
                modelContext: MovieFinderApp.sharedModelContainer.mainContext
            )
        }.singleton
    }

    // MARK: - Repository
    var watchlistRepository: Factory<WatchlistRepositoryProtocol> {
        self {
            @MainActor in
            WatchlistRepository(dataSource: self.watchlistDataSource())
        }.singleton
    }

    // MARK: - Use Cases
    var addToWatchlistUseCase: Factory<AddToWatchlistUseCase> {
        self {
            @MainActor in
            AddToWatchlistUseCase(repository: self.watchlistRepository())
        }
    }

    var removeFromWatchlistUseCase: Factory<RemoveFromWatchlistUseCase> {
        self {
            @MainActor in
            RemoveFromWatchlistUseCase(repository: self.watchlistRepository())
        }
    }

    var getAllWatchlistUseCase: Factory<GetAllWatchlistUseCase> {
        self {
            @MainActor in
            GetAllWatchlistUseCase(repository: self.watchlistRepository())
        }
    }

    var checkWatchlistStatusUseCase: Factory<CheckWatchlistStatusUseCase> {
        self {
            @MainActor in
            CheckWatchlistStatusUseCase(repository: self.watchlistRepository())
        }
    }

    var getWatchlistCountUseCase: Factory<GetWatchlistCountUseCase> {
        self {
            @MainActor in
            GetWatchlistCountUseCase(repository: self.watchlistRepository())
        }
    }

    // MARK: - ViewModel
    var watchlistViewModel: Factory<WatchlistViewModel> {
        self {
            @MainActor in
            WatchlistViewModel(
                getAllWatchlistUseCase: self.getAllWatchlistUseCase(),
                removeFromWatchlistUseCase: self.removeFromWatchlistUseCase(),
                getWatchlistCountUseCase: self.getWatchlistCountUseCase()
            )
        }
    }
}
