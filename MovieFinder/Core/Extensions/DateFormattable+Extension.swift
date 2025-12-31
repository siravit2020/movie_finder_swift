//
//  DateFormattable+Extension.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/7/2568 BE.
//

import Foundation

protocol DateFormattable {
    var releaseDate: String { get }
}

extension DateFormattable {
    var formattedReleaseDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: releaseDate) else {
            return "Not Available"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long  // "July 27, 2025"
        outputFormatter.timeStyle = .none

        return outputFormatter.string(from: date)
    }
}
