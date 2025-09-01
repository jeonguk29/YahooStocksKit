//
//  ChartService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public final class ChartService {
    
    private let apiService: APIRequestable
    
    public init(apiService: APIRequestable) {
        self.apiService = apiService
    }
    
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
        
        let response = try await apiService.request(
            endpoint: endpoint,
            responseType: ChartResponse.self
        )
        
        // 서버가 200을 반환했지만, body에 에러 정보가 들어있는 경우
        if let error = response.error {
            throw APIServiceError.httpStatusCodeFailed(statusCode: 200, error: error)
        }
        
        guard let chartData = response.data?.first else {
            throw APIServiceError.invalidResponseType
        }
        
        return chartData
    }
}
