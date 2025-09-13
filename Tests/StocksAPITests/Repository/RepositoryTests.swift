//
//  RepositoryTests.swift
//  YahooStocksKit
//
//  Created by jeonguk29 on 9/1/25.
//

import Testing
@testable import StocksAPI
import Foundation

// MARK: - Mock Repository
final class MockStockRepository: StockServiceProtocol {
    var mockTickers: [Ticker] = []
    var mockQuotes: [Quote] = []
    var mockChartData: ChartData?

    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        return mockTickers
    }

    func fetchQuotes(symbols: String) async throws -> [Quote] {
        return mockQuotes
    }

    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData? {
        return mockChartData
    }
}

// MARK: - Repository Tests
struct RepositoryTests {
    
    @Test("MockRepository를 통해 종목 검색이 정상 동작한다")
    ///searchTickers 동작 검증.
    ///실제 API 요청이 아니라, Mock에 심어둔 Ticker(symbol: "AAPL")이 반환되는지 확인.

    func searchTickers() async throws {
        let mockRepo = MockStockRepository()
        mockRepo.mockTickers = [Ticker(symbol: "AAPL", shortname: "Apple")]

        let result = try await mockRepo.searchTickers(query: "AAPL", isEquityTypeOnly: true)

        #expect(result.count == 1)
        #expect(result.first?.symbol == "AAPL")
    }

    @Test("MockRepository를 통해 시세 조회가 정상 동작한다")
    ///시세 조회 테스트. 네트워크 없이도, AAPL 종목이 190달러로 리턴되는지 확인
    
    func fetchQuotes() async throws {
        let mockRepo = MockStockRepository()
        mockRepo.mockQuotes = [Quote(symbol: "AAPL", regularMarketPrice: 190.0, regularMarketChange: 1.5)]

        let result = try await mockRepo.fetchQuotes(symbols: "AAPL")

        #expect(result.count == 1)
        #expect(result.first?.symbol == "AAPL")
        #expect(result.first?.regularMarketPrice == 190.0)
    }

    @Test("MockRepository를 통해 차트 데이터 조회가 정상 동작한다")
    func fetchChartData() async throws {
        let mockRepo = MockStockRepository()

        // 더미 ChartData 생성
        let dummyMetadata = ChartData.Metadata(symbol: "AAPL")
        let dummyIndicators = [
            ChartData.Indicator(timestamp: Date(timeIntervalSince1970: 1), open: 100, high: 110, low: 90, close: 105),
            ChartData.Indicator(timestamp: Date(timeIntervalSince1970: 2), open: 106, high: 112, low: 95, close: 108)
        ]
        let dummyChart = ChartData(metadata: dummyMetadata, indicators: dummyIndicators)

        mockRepo.mockChartData = dummyChart

        let result = try await mockRepo.fetchChartData(tickerSymbol: "AAPL", range: .oneDay)

        #expect(result?.metadata.symbol == "AAPL")
        #expect(result?.indicators.count == 2)
    }
}
