//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class TickerSearchService {
    
    public static let shared = TickerSearchService()
    
    private init() {}
    
    public func getTicker(query: String) async throws -> SearchTickerResponse {
        let endpoint = Endpoint.YahooFinance.searchTicker(region: "US", query: query).endpointItem
        
        return try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
            responseType: SearchTickerResponse.self
        )
    }
}
