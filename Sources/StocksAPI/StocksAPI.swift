// The Swift Programming Language
// https://docs.swift.org/swift-book

import StocksAPI
import Foundation

public protocol StockServiceProtocol {
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData?
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
}

public final class StocksAPI: StockServiceProtocol {
    
    // 싱글톤 지원
    public static let shared: StocksAPI = {
        let config = APIConfig.load()!
        let apiService = APIService(config: config)
        return StocksAPI(apiService: apiService)
    }()
    
    private let quoteService: QuoteService
    private let chartService: ChartService
    private let tickerSearchService: TickerSearchService
    
    // 필요하면 외부에서 의존성 주입도 가능
    public init(apiService: APIRequestable) {
        self.quoteService = QuoteService(apiService: apiService)
        self.chartService = ChartService(apiService: apiService)
        self.tickerSearchService = TickerSearchService(apiService: apiService)
    }
    
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
