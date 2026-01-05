//
//  MovieDetailScreen.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/7/2568 BE.
//

import FactoryKit
import Kingfisher
import SwiftUI

struct MovieDetailScreen: View {
    var movieId: Int

    @InjectedObject(\.movieDetailViewModel) private var viewModel
    @State private var isShowingVideoPlayer = false

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    if viewModel.isLoading {
                        MovieDetailSkeletonView(
                            maxWidth: geometry.size.width,
                            maxHeight: geometry.size.height
                        )
                    } else if let movie = viewModel.movieDetail {
                        VStack(alignment: .leading, spacing: 0) {
                            if let backdropURL = movie.backdropURL {
                                BackdropView(
                                    backdropURL: backdropURL,
                                    maxHeight: geometry.size.height,
                                    maxWidth: geometry.size.width
                                )
                            }
                            HStack(spacing: .Spacing.space16) {
                                MovieImage(url: movie.posterURL)
                                    .frame(
                                        width: 120,
                                        height: 120 * 1.513,
                                    )

                                VStack(
                                    alignment: .leading,
                                    spacing: .Spacing.space8
                                ) {

                                    Text(movie.title).title1Style()
                                    FlowLayout(spacing: 8) {
                                        ForEach(
                                            0..<movie.genres.count,
                                            id: \.self
                                        ) { index in
                                            HStack(spacing: 4) {
                                                Text(movie.genres[index].name)
                                                    .subheadlineStyle()
                                                if index < movie.genres.count
                                                    - 1
                                                {
                                                    Color.primaryAccent.frame(
                                                        width: 6,
                                                        height: 6
                                                    )
                                                    .clipShape(Circle())
                                                    .padding(.horizontal, 2)
                                                }
                                            }
                                        }
                                    }
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(.primaryAccent)

                                        Text(movie.formattedReleaseDate)
                                            .subheadlineStyle()
                                    }

                                }
                            }.padding(.horizontal, .Spacing.space24).offset(
                                y: -(120 * 1.513 / 2)
                            )
                            .padding(.bottom, -(120 * 1.513) / 2)

                            HStack {
                                VStack {
                                    Button {
                                        isShowingVideoPlayer = true
                                    } label: {
                                        Image(systemName: "play.fill")
                                            .foregroundStyle(
                                                .textPrimary
                                            )
                                        Text("Trailer").subheadlineStyle()
                                    }
                                }.padding(
                                    .all,
                                    .Spacing.space8
                                )
                                .background(
                                    Color.primaryAccent.opacity(0.3)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(
                                        .primaryAccent,
                                        lineWidth: 2
                                    )

                                }
                                .cornerRadius(
                                    8
                                )
                                Spacer()
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundStyle(
                                            .primaryAccent
                                        )
                                        .font(.system(size: 20))

                                    VStack(spacing: 2) {
                                        Text("Duration").subheadlineStyle()
                                        Text(movie.duration).subheadlineStyle()
                                    }
                                }
                                Spacer()
                                CircleProgress(
                                    value: movie.voteAverage * 10,
                                )

                            }
                            .sheet(isPresented: $isShowingVideoPlayer) {
                                if let video = viewModel.movieVideo?.trailer?
                                    .key
                                {
                                    YouTubePlayerView(
                                        videoId: video,
                                        isPresented: $isShowingVideoPlayer
                                    )
                                }
                            }
                            .padding(.top, .Spacing.space24)
                            .padding(.horizontal, .Spacing.space24)

                            Text(movie.overview).bodyStyle()
                                .padding(.horizontal, .Spacing.space24)
                                .padding(.top, .Spacing.space24)
                            if !viewModel.isInWatchlist {
                                Button {
                                    Task {
                                        await viewModel.addToWatchlist(
                                            movie: movie
                                        )
                                    }
                                } label: {
                                    Text("Add to Watchlist").foregroundStyle(
                                        .black
                                    )
                                    .buttonLabelStyle()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.Spacing.space12)
                                .background(.primaryAccent)
                                .cornerRadius(12)
                                .padding(.horizontal, .Spacing.space24)
                                .padding(.top, .Spacing.space24)
                            } else {
                                Button {
                                    Task {
                                        await viewModel.removeFromWatchlist(
                                            movie: movie
                                        )
                                    }
                                } label: {
                                    Text("Remove from Watchlist")
                                        .foregroundStyle(
                                            .textPrimary
                                        )
                                        .buttonLabelStyle()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.Spacing.space12)
                                .background(.removeButton)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal, .Spacing.space24)
                                .padding(.top, .Spacing.space24)

                            }

                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Spacer()
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .background(Color.primaryBackground)
                .onAppear {
                    Task {
                        await viewModel.initialize(movieId: movieId)
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
            }
        }

    }
}

#Preview {
    let _ = Container.shared.movieDetailRepository.register {
        MockMovieDetailRepository()
    }
    MovieDetailScreen(movieId: 1)
}
