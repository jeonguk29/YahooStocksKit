//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class TickerSearchService {
    private let config: APIConfig

    public init(config: APIConfig) {
        self.config = config
    }

    public func fetchTicker(symbol: String) async throws -> SearchTickerResponse {
        guard let url = URL(string: "https://yh-finance.p.rapidapi.com/auto-complete?region=US&q=\(symbol)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(config.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(SearchTickerResponse.self, from: data)
    }
}
