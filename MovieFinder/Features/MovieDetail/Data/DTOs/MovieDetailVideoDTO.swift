//
//  MovieDetailVideo.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 28/7/2568 BE.
//

import Foundation

struct VideoResponseDTO: Codable {
    let id: Int
    let results: [VideoDTO]
}

struct VideoDTO: Codable, Identifiable {
    let id: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case name, key, site, size, type, official, id
        case publishedAt = "published_at"
    }
}
