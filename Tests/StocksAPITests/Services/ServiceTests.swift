//
//  Test.swift
//  YahooStocksKit
//
//  Created by jeonguk29 on 9/1/25.
//

import Testing
import Foundation
@testable import StocksAPI

// MARK: - QuoteServiceTests
struct QuoteServiceTests {
    
    @Test("QuoteService가 정상 응답을 디코딩한다")
    func fetchQuotesSuccess() async throws {
        defer { MockURLProtocol.mockResponse = nil }
        
        let json = """
        { "quoteResponse": { "result": [ { "symbol": "AAPL" } ], "error": null } }
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                       statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (json, response, nil)
        
        let service = QuoteService(apiService: APIService.makeMocked())
        let quotes = try await service.fetchQuotes(symbols: "AAPL")
        
        #expect(quotes.first?.symbol == "AAPL")
    }
}

// MARK: - TickerSearchServiceTests
struct TickerSearchServiceTests {
    
    @Test("TickerSearchService가 정상 응답을 디코딩한다")
    func searchTickersSuccess() async throws {
        defer { MockURLProtocol.mockResponse = nil }
        
        let json = """
        {
          "quotes": [
            {
              "symbol": "AAPL",
              "shortname": "Apple",
              "longname": "Apple Inc.",
              "quoteType": "EQUITY",
              "exchDisp": "NASDAQ",
              "sector": "Technology",
              "industry": "Consumer Electronics"
            }
          ],
          "finance": {
            "error": null
          }
        }
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                       statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (json, response, nil)
        
        let service = TickerSearchService(apiService: APIService.makeMocked())
        let tickers = try await service.searchTickers(query: "AAPL", isEquityTypeOnly: true)
        
        #expect(tickers.first?.symbol == "AAPL")
    }
}

// MARK: - ChartServiceTests
struct ChartServiceTests {
    
    @Test("ChartService가 정상 응답을 디코딩한다")
    func fetchChartDataSuccess() async throws {
        defer { MockURLProtocol.mockResponse = nil }
        
        let json = """
        { "chart": { "result": [ { "meta": { "symbol": "AAPL" } } ], "error": null } }
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                       statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (json, response, nil)
        
        let service = ChartService(apiService: APIService.makeMocked())
        let chartData = try await service.fetchChartData(tickerSymbol: "AAPL", range: .oneDay)
        
        #expect(chartData.metadata.symbol == "AAPL")
    }
}
