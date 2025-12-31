//
//  APIError.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 31/7/2568 BE.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case encodingError

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let message):
            return "Network error: \(message.localizedDescription)"
        case .encodingError:
            return "Failed to encode request body"
        }
    }
}
