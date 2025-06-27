//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class QuoteService {
    private let config: APIConfig

    public init(config: APIConfig) {
        self.config = config
    }

    public func fetchQuotes(symbols: [String]) async throws -> QuoteResponse {
        let symbolsQuery = symbols.joined(separator: ",")
        guard let url = URL(string: "https://yh-finance.p.rapidapi.com/market/v2/get-quotes?symbols=\(symbolsQuery)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(config.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(QuoteResponse.self, from: data)
    }
}
