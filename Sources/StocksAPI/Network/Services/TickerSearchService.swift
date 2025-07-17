//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation


public final class TickerSearchService {
    
    public static let shared = TickerSearchService()
    
    public init() {}
    
    public func searchTickers(query: String, isEquityTypeOnly: Bool = true) async throws -> [Ticker] {
        let endpoint = Endpoint.YahooFinance.searchTicker(region: "US", query: query).endpointItem
        
        let response = try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
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
