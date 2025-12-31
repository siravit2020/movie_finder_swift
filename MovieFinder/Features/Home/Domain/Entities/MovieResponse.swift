import Foundation

struct MovieResponse {
    let dates: DateRange?
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    struct DateRange {
        let maximum: String
        let minimum: String
    }
}
