//
//  ChartService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public final class ChartService {
    
    public static let shared = ChartService()
    
    public init() {}
    
    public func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData {
        let endpoint = Endpoint.YahooFinance.getChart(
            symbol: tickerSymbol,
            range: range.rawValue,
            interval: range.interval,
            region: "US",
            includePrePost: false,
            useYfid: true,
            includeAdjustedClose: true,
            events: "capitalGain,div,split"
        ).endpointItem
        
        let response = try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
            responseType: ChartResponse.self
        )
        
        if let error = response.error {
            throw APIServiceError.httpStatusCodeFailed(statusCode: 200, error: error)
        }
        
        guard let chartData = response.data?.first else {
            throw APIServiceError.invalidResponseType
        }
        
        return chartData
    }
}
