//
//  MovieRow.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import SwiftUI

struct MovieRow: View {
    var movie: Movie

    var body: some View {
        HStack(alignment: .top) {
            MovieImage(url: movie.posterURL)
                .frame(width: 100)
                .padding(
                    .trailing,
                    .Spacing.space8
                )
            VStack(alignment: .leading) {
                Text(movie.title).title2Style().padding(
                    .bottom,
                    .Spacing.space4
                )
                Text(movie.releaseDate).subheadlineStyle().padding(
                    .bottom,
                    .Spacing.space4
                )
                HStack {
                    Image(systemName: "heart.fill").foregroundStyle(.red)
                    Text("\(Int(movie.popularity))").subheadlineStyle()

                }.padding(.bottom, .Spacing.space8)
                CircleProgress(
                    value: movie.voteAverage * 10,
                    enableBackground: false
                )
            }
        }
    }
}

#Preview {
    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieResponse = MovieResponseMapper.map(dto: responseDTO)

    if let firstMovie = movieResponse.results.first {
        MovieRow(movie: firstMovie)
            .padding()
            .background(Color.primaryBackground)
    } else {
        Text("ไม่พบข้อมูลหนังในไฟล์ JSON")
    }
}
