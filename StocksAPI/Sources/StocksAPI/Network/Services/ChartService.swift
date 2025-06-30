//
//  ChartService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public final class ChartService {
    
    public static let shared = ChartService()
    
    private init() {}
    
    public func getChart(symbol: String, range: ChartRange) async throws -> ChartResponse {
        let endpoint = Endpoint.YahooFinance.getChart(
            symbol: symbol,
            range: range.rawValue,
            interval: range.interval,
            region: "US",
            includePrePost: false,
            useYfid: true,
            includeAdjustedClose: true,
            events: "capitalGain,div,split"
        ).endpointItem
        
        return try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
            responseType: ChartResponse.self
        )
    }
}
