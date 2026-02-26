//
//  APIRequestLoader.swift
//  Coins
//
//  Created by 홍다희 on 2021/11/15.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case client
    case server(statusCode: Int, data: Data?)
    case parseResponse
}

public final class APIRequestLoader: Sendable {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func request<T, U>(with endpoint: T) async throws -> U where T: RequestType, T.ResponseType == U {
        guard let urlRequest = endpoint.makeRequest() else {
            throw APIError.invalidURL
        }

        let (data, response) = try await urlSession.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw APIError.server(statusCode: httpResponse.statusCode, data: data)
        }
        
        guard let value = endpoint.parseResponse(data: data) else {
            throw APIError.parseResponse
        }
        
        return value
    }
}
