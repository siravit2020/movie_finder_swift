//
//  Video.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 8/12/2568 BE.
//

import Foundation

struct VideoResponse: Identifiable {
    let id: Int
    let results: [Video]

    var trailer: Video? {
        return results.first(where: { $0.type == "Trailer" })
    }
}

struct Video: Identifiable {
    let id: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String

    var videoURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(
            string: "https://www.youtube.com/watch?v=\(key)"
        )
    }

    var thumbnailURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(
            string: "https://img.youtube.com/vi/\(key)/maxresdefault.jpg"
        )
    }
}
