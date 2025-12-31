//
//  Encodable.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 31/7/2568 BE.
//

import Foundation

extension Encodable {
    /// แปลง object ที่เป็น Encodable ให้กลายเป็น Dictionary [String: Any]
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard
            let dictionary = try JSONSerialization.jsonObject(with: data)
                as? [String: Any]
        else {
            throw APIError.encodingError
        }
        return dictionary
    }
}
