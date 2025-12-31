//
//  MovieListView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 16/8/2568 BE.
//

import FactoryKit
import SwiftUI

struct MovieListView: View {
    let title: String
    let items: [Movie]
    let onItemAppear: (Movie) -> Void
    let canLoadMore: Bool

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: .Spacing.space16),
        GridItem(.flexible(), spacing: .Spacing.space16),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: .Spacing.space16) {
                    ForEach(items) { item in
                        NavigationLink {
                            MovieDetailScreen(movieId: item.id)
                        } label: {
                            MovieListItem(movie: item)
                                .onAppear {
                                    onItemAppear(
                                        item
                                    )
                                }
                        }

                    }
                }
                .padding(.horizontal, .Spacing.space24)
                .padding(.top, .Spacing.space24)

                if canLoadMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .navigationTitle(title)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color.primaryBackground)
    }
}

#Preview {
    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieResponse = MovieResponseMapper.map(dto: responseDTO)
    MovieListView(
        title: "Now Playing",
        items: movieResponse.results,
        onItemAppear: { Movie in

        },
        canLoadMore: false
    )
}
