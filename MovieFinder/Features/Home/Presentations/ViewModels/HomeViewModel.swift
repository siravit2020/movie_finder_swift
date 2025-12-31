//
//  HomeNewModel.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 19/7/2568 BE.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    private let fetchNowShowing: FetchNowShowingMoviesUseCase
    private let fetchPopular: FetchPopularMoviesUseCase

    @Published var nowShowing: MovieResponse? = nil
    @Published var popular: MovieResponse? = nil
    @Published var isLoading = false

    init(
        fetchNowShowing: FetchNowShowingMoviesUseCase,
        fetchPopular: FetchPopularMoviesUseCase
    ) {
        self.fetchNowShowing = fetchNowShowing
        self.fetchPopular = fetchPopular
    }

    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }  // ใช้ defer เพื่อให้แน่ใจว่า isLoading จะถูกเปลี่ยนเป็น false เสมอ

        async let nowShowingTask = fetchNowShowing.execute(params: MovieRequestParams(page: 1))
        async let popularTask = fetchPopular.execute(params: MovieRequestParams(page: 1))

        do {
            // รอผลลัพธ์ทั้งสองอย่างพร้อมกัน
        let (nowShowingResponse, popularResponse) = try await (
                nowShowingTask, popularTask
            )
            self.nowShowing = nowShowingResponse
            self.popular = popularResponse
        } catch {
            print("Error fetching movies: \(error)")
            // อาจจะมีการจัดการ error ที่ดีกว่านี้
        }
    }
}
