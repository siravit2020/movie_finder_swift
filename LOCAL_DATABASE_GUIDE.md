//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 17/7/2568 BE.
//

import SwiftData
import SwiftUI

@main
struct MovieFinderApp: App {

    let modelContainer: ModelContainer

    init() {
        // ตั้งค่า Kingfisher cache
        KingfisherConfig.setup()

        // สร้าง ModelContainer สำหรับ SwiftData
        do {
            modelContainer = try ModelContainer(for: WatchlistMovie.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
