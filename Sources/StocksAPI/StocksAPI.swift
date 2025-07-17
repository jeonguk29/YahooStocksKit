// The Swift Programming Language
// https://docs.swift.org/swift-book

import StocksAPI
import Foundation

public protocol StockServiceProtocol {
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData?
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
}

public final class StocksAPI {
    
    public static let shared = StocksAPI()
    
    public let quoteService: QuoteService
    public let chartService: ChartService
    public let tickerSearchService: TickerSearchService
    
    public init() {
        self.quoteService = QuoteService()
        self.chartService = ChartService()
        self.tickerSearchService = TickerSearchService()
    }
}

extension StocksAPI: StockServiceProtocol{
    public func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        try await tickerSearchService.searchTickers(query: query, isEquityTypeOnly: isEquityTypeOnly)
    }
    
    public func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await quoteService.fetchQuotes(symbols: symbols)
    }
    
    public func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData? {
        try await chartService.fetchChartData(tickerSymbol: tickerSymbol, range: range)
    }
}
