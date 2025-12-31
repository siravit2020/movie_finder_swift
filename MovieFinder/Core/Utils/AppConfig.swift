//
//  AppConfig.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 18/7/2568 BE.
//

import Foundation

enum AppConfig {

    private static func value(forKey key: String) -> String? {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String
        else {
            print(
                "❌ ERROR: Key '\(key)' not found in Info.plist. Make sure it's set in the .xcconfig and Info.plist."
            )
            return nil
        }
        return value
    }

    static var apiKey: String {
        return value(forKey: "API_KEY") ?? ""
    }

    static var apiBaseURL: String {
        return value(forKey: "API_BASE_URL") ?? ""
    }

    static var apiBaseImageURL: String {
        return value(forKey: "API_BASE_IMAGE_URL") ?? ""
    }
}
