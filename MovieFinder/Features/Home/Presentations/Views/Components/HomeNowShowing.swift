//
//  HomeNowShowing.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 1/1/2569 BE.
//

import SwiftUI

struct HomeNowShowing: View {
    let movieList: MovieResponse

    var body: some View {
        HeaderSection(
            text: "Now Showing",
            onSeeMore: { NowShowingView() }
        )
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
}

#Preview {
    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieList = MovieResponseMapper.map(dto: responseDTO)
    HomeNowShowing(movieList: movieList)
}
