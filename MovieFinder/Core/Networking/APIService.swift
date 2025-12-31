//
//  HomeAPIService.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 19/7/2568 BE.
//

import Foundation

protocol APIServiceProtocol {
    func get<T: Codable, P: Encodable>(from urlString: String, params: P?)
        async throws -> T
    func post<T: Codable, B: Encodable>(to urlString: String, body: B)
        async throws -> T
    func put<T: Codable, B: Encodable>(to urlString: String, body: B)
        async throws -> T
    func delete<T: Codable>(from urlString: String) async throws -> T
}

class APIService: APIServiceProtocol {

    func get<T: Codable, P: Encodable>(from urlString: String, params: P?)
        async throws -> T
    {
        return try await request(
            from: urlString,
            method: .get,
            queryParams: params
        )
    }

    func post<T: Codable, B: Encodable>(to urlString: String, body: B)
        async throws -> T
    {
        return try await request(
            from: urlString,
            method: .post,
            body: body
        )
    }

    func put<T: Codable, B: Encodable>(to urlString: String, body: B)
        async throws -> T
    {
        return try await request(
            from: urlString,
            method: .put,
            body: body
        )
    }

    func delete<T: Codable>(from urlString: String) async throws -> T {
        return try await request(
            from: urlString,
            method: .delete
        )
    }

    // MARK: - Private Core Request Function

    private func request<T: Codable>(
        from urlString: String,
        method: HTTPMethod,
        body: (any Encodable)? = nil,
        queryParams: (any Encodable)? = nil
    ) async throws -> T {

        guard var urlComponents = URLComponents(string: urlString) else {
            throw APIError.invalidURL
        }

        if let paramsDict = try queryParams?.toDictionary() {
            urlComponents.queryItems = paramsDict.compactMap { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(AppConfig.apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {

            throw APIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            throw APIError.decodingError(error)
        }
    }
}
