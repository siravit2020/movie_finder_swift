//
//  MovieListItem.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import SwiftUI

struct MovieListItem: View {
    let imageURL: URL?
    let title: String
    let voteAverage: Double

    init(movie: Movie) {
        self.imageURL = movie.posterURL
        self.title = movie.title
        self.voteAverage = movie.voteAverage
    }

    init(watchlistMovie: WatchlistMovie) {
        self.imageURL = watchlistMovie.posterURL
        self.title = watchlistMovie.title
        self.voteAverage = watchlistMovie.voteAverage
    }

    init(imageURL: URL?, title: String, voteAverage: Double) {
        self.imageURL = imageURL
        self.title = title
        self.voteAverage = voteAverage
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                MovieImage(url: imageURL)
                    .padding(
                        .bottom,
                        20
                    )
                CircleProgress(value: voteAverage * 10).padding(
                    .leading,
                    8
                )
            }
            Text(title)
                .title2Style()
                .lineLimit(2, reservesSpace: true)
                .truncationMode(.tail).padding(
                    .leading,
                    8
                )
        }

    }
}

#Preview {

    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieResponse = MovieResponseMapper.map(dto: responseDTO)

    if let firstMovie = movieResponse.results.first {
        VStack(spacing: 20) {
            // Option B: Custom Init (Swift-style)
            MovieListItem(movie: firstMovie)

            // Original: ยังใช้ได้
            MovieListItem(
                imageURL: firstMovie.posterURL,
                title: firstMovie.title,
                voteAverage: firstMovie.voteAverage
            )
        }
        .padding()
        .background(Color.primaryBackground)
    } else {
        Text("ไม่พบข้อมูลหนังในไฟล์ JSON")
    }
}
