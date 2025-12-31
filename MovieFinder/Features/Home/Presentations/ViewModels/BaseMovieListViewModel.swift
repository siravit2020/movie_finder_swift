//
//  BaseMovieListViewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import SwiftUI

@MainActor
class BaseMovieListViewModel: ObservableObject {
    @Published var items: [Movie] = []
    @Published var isLoading = false
    @Published var canLoadMore = true

    private var currentPage = 1

    func fetchInitialItems() {
        // โหลดข้อมูลชุดแรก
        guard !isLoading else { return }

        Task {
            await fetchMoreItems()
        }
    }

    func fetchMoreItemsIfNeeded(currentItem: Movie?) {
        guard !isLoading else { return }

        guard let currentItem = currentItem else { return }

        let count = items.count
        guard count >= 5 else { return }

        let thresholdItem = items[count - 5]

        if currentItem.id == thresholdItem.id {
            Task {
                await fetchMoreItems()
            }
        }
    }

    private func fetchMoreItems() async {

        guard !isLoading && canLoadMore else { return }

        isLoading = true

        print("Fetching page \(currentPage)...")

        do {

            // รอผลลัพธ์ทั้งสองอย่างพร้อมกัน
            let nowShowingResponse = try await executeUseCase(
                params: MovieRequestParams(page: currentPage)
            )

            if nowShowingResponse.page == nowShowingResponse.totalPages {
                self.canLoadMore = false
            }

            self.items.append(contentsOf: nowShowingResponse.results)  // 4. นำข้อมูลใหม่มาต่อท้าย
            self.currentPage += 1
            self.isLoading = false
            print("Finished fetching. Total items: \(self.items.count)")

        } catch {
            print("Error fetching movies: \(error)")
            // อาจจะมีการจัดการ error ที่ดีกว่านี้
        }

    }

    // Abstract methods - ต้อง override ใน subclass
    func executeUseCase(params: MovieRequestParams) async throws
        -> MovieResponse
    {
        fatalError("Must be overridden in subclass")
    }
}
