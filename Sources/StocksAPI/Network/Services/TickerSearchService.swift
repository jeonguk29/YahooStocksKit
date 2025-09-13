//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class TickerSearchService {
    
    private let apiService: APIRequestable
    
    // 기본은 실제 APIService를 주입
    public init(apiService: APIRequestable) {
        self.apiService = apiService
    }
    
    public func searchTickers(query: String, isEquityTypeOnly: Bool = true) async throws -> [Ticker] {
        let endpoint = Endpoint.YahooFinance.searchTicker(region: "US", query: query).endpointItem
        
        let response = try await apiService.request(
            endpoint: endpoint,
            responseType: SearchTickerResponse.self
        )
        
        let tickers = response.data ?? []
        
        if isEquityTypeOnly {
            return tickers.filter { ($0.quoteType ?? "").localizedCaseInsensitiveCompare("equity") == .orderedSame }
        } else {
            return tickers
        }
    }
}
