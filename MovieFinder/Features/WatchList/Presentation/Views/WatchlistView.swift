//
//  WatchlistView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 10/12/2568 BE.
//

import FactoryKit
import SwiftData
import SwiftUI

struct WatchlistView: View {
    @InjectedObject(\.watchlistViewModel) private var viewModel

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: .Spacing.space16),
        GridItem(.flexible(), spacing: .Spacing.space16),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if viewModel.movies.isEmpty {
                    emptyStateView
                } else {
                    movieListView
                }

            }
            .navigationTitle("Watchlist")
            .task {
                await viewModel.loadWatchlist()
            }
            .alert(
                "Error",
                isPresented: .constant(viewModel.errorMessage != nil)
            ) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
            .background(Color.primaryBackground)
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Movies",
            systemImage: "film.stack",
            description: Text("Add movies to your watchlist to see them here")
        )
    }

    private var movieListView: some View {
        LazyVGrid(columns: columns, spacing: .Spacing.space16) {
            ForEach(viewModel.movies) { item in
                NavigationLink {
                    MovieDetailScreen(movieId: item.id)
                } label: {
                    MovieListItem(watchlistMovie: item)
                }

            }
        }
        .padding(.horizontal, .Spacing.space24)
        .padding(.top, .Spacing.space24)
    }
}

struct MovieRowView: View {
    let movie: WatchlistMovie

    var body: some View {
        HStack {
            // Movie poster
            AsyncImage(url: posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private var posterURL: URL? {
        guard let posterPath = movie.posterURL else { return nil }
        return URL(string: "\(AppConfig.apiBaseImageURL)w200\(posterPath)")
    }
}

#Preview {
    WatchlistView()
}
