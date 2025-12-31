import Foundation

struct Movie: Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let baseImageURL = AppConfig.apiBaseImageURL
        return URL(string: baseImageURL + "w500" + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let baseImageURL = AppConfig.apiBaseImageURL
        return URL(string: baseImageURL + "original" + backdropPath)
    }
}
