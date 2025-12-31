//
//  VideoMapper.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 8/12/2568 BE.
//

import Foundation

enum VideoMapper {
    static func map(dto: VideoResponseDTO) -> VideoResponse {
        return VideoResponse(
            id: dto.id,
            results: dto.results.map { map(dto: $0) }
        )
    }
    
    static func map(dto: VideoDTO) -> Video {
        return Video(
            id: dto.id,
            name: dto.name,
            key: dto.key,
            site: dto.site,
            size: dto.size,
            type: dto.type,
            official: dto.official,
            publishedAt: dto.publishedAt
        )
    }
}
