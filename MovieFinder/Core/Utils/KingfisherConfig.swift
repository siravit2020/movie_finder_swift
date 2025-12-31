//
//  KingfisherConfig.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 8/12/2568 BE.
//

import Foundation
import Kingfisher

struct KingfisherConfig {
    static func setup() {
        // ตั้งค่า Memory Cache - 100MB
        ImageCache.default.memoryStorage.config.totalCostLimit =
            100 * 1024 * 1024

        // ตั้งค่า Disk Cache - 500MB
        ImageCache.default.diskStorage.config.sizeLimit = 500 * 1024 * 1024

        // ตั้งเวลา cache - 7 วัน
        ImageCache.default.diskStorage.config.expiration = .days(7)

        // ตั้งค่า Downloader timeout
        ImageDownloader.default.downloadTimeout = 15.0
    }

    /// ลบ cache ทั้งหมด
    static func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }

    /// ลบ cache ที่หมดอายุ
    static func clearExpiredCache() {
        ImageCache.default.cleanExpiredDiskCache()
    }

    /// คำนวณขนาด cache
    static func calculateCacheSize(completion: @escaping (UInt) -> Void) {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                completion(size)
            case .failure:
                completion(0)
            }
        }
    }
}
