//
//  HomeView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 17/7/2568 BE.
//

import FactoryKit
import SwiftUI

struct HomeView: View {
    @InjectedObject(\.homeViewModel) private var viewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, ) {

                    AccountSection()

                    HeaderSection(
                        text: "Now Showing",
                        onSeeMore: { NowShowingView() }
                    )

                    if let movieList = viewModel.nowShowing {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: .Spacing.space16) {
                                ForEach(movieList.results) { movie in
                                    NavigationLink {
                                        MovieDetailScreen(movieId: movie.id)
                                    } label: {
                                        MovieListItem(movie: movie).frame(
                                            width: 150
                                        )
                                    }

                                }
                            }
                            .padding(.horizontal, .Spacing.space24).padding(
                                .vertical,
                                .Spacing.space16
                            )
                        }
                    }

                    HeaderSection(
                        text: "Popular",
                        onSeeMore: { PopularMovieView() }
                    )

                    if let movieList = viewModel.nowShowing {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(
                                alignment: .leading,
                                spacing: .Spacing.space16
                            ) {
                                ForEach(movieList.results) { movie in
                                    NavigationLink {
                                        MovieDetailScreen(movieId: movie.id)
                                    } label: {
                                        MovieRow(movie: movie)
                                    }
                                }
                            }
                            .padding(.horizontal, .Spacing.space24).padding(
                                .vertical,
                                .Spacing.space16
                            )
                        }
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color.primaryBackground)
            .task {
                await viewModel.loadMovies()
            }
        }

    }
}

#Preview {
    let _ = Container.shared.movieRepository.register { MockHomeRepository() }
    HomeView()
}
