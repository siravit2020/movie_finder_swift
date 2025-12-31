import Foundation

struct MovieResponseDTO: Codable {
    let dates: DateRange?
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    struct DateRange: Codable {
        let maximum: String
        let minimum: String
    }
}
