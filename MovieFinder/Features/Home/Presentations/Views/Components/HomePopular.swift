//
//  HomePopular.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 1/1/2569 BE.
//

import SwiftUI

struct HomePopular: View {
    let movieList: MovieResponse
    var body: some View {
        HeaderSection(
            text: "Popular",
            onSeeMore: { PopularMovieView() }
        )
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

#Preview {
    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieList = MovieResponseMapper.map(dto: responseDTO)
    HomePopular(movieList: movieList)
}
