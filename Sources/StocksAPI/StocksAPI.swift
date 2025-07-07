// The Swift Programming Language
// https://docs.swift.org/swift-book

import StocksAPI

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
