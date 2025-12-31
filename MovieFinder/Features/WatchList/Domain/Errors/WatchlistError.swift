//
//  WatchlistError.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import Foundation

enum WatchlistError: LocalizedError {
    case notFound(id: Int)
    case alreadyExists(id: Int)
    case databaseError(Error)
    case invalidData
    case operationFailed(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Movie with ID \(id) not found in watchlist"
        case .alreadyExists(let id):
            return "Movie with ID \(id) already exists in watchlist"
        case .databaseError(let error):
            return "Database error: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data provided"
        case .operationFailed(let message):
            return "Operation failed: \(message)"
        }
    }
}
