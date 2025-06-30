//
//  ChartService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public final class ChartService {
    private let config: APIConfig

    public init(config: APIConfig) {
        self.config = config
    }

    public func fetchChart(symbol: String) async throws -> ChartResponse {
        guard let url = URL(string: "https://yh-finance.p.rapidapi.com/stock/v3/get-chart?interval=1mo&symbol=\(symbol)&range=5y&region=US&includePrePost=false&useYfid=true&includeAdjustedClose=true&events=capitalGain%2Cdiv%2Csplit") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(config.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ChartResponse.self, from: data)
    }
}
