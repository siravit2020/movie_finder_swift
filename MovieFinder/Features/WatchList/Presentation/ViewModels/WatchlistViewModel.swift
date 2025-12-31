//
//  WatchlistViewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

@MainActor
class WatchlistViewModel: ObservableObject {
    @Published var movies: [WatchlistMovie] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    // Use Cases
    private let getAllWatchlistUseCase: GetAllWatchlistUseCase
    private let removeFromWatchlistUseCase: RemoveFromWatchlistUseCase
    private let getWatchlistCountUseCase: GetWatchlistCountUseCase

    init(
        getAllWatchlistUseCase: GetAllWatchlistUseCase,
        removeFromWatchlistUseCase: RemoveFromWatchlistUseCase,
        getWatchlistCountUseCase: GetWatchlistCountUseCase
    ) {
        self.getAllWatchlistUseCase = getAllWatchlistUseCase
        self.removeFromWatchlistUseCase = removeFromWatchlistUseCase
        self.getWatchlistCountUseCase = getWatchlistCountUseCase
    }

    func loadWatchlist(
        sortBy: WatchlistSortOption = .dateAdded(ascending: false)
    ) async {
        isLoading = true
        errorMessage = nil

        do {
            movies = try await getAllWatchlistUseCase.execute(sortBy: sortBy)
        } catch let error as WatchlistError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Unknown error occurred"
        }

        isLoading = false
    }

    func removeMovie(id: Int) async {
        do {
            try await removeFromWatchlistUseCase.execute(id: id)
            await loadWatchlist()
        } catch let error as WatchlistError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Failed to remove movie"
        }
    }

    func getWatchlistCount() async -> Int {
        (try? await getWatchlistCountUseCase.execute()) ?? 0
    }
}
