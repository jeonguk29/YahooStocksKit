//
//  StocksAPIExec.swift
//  StocksAPIExec
//
//  Created by 정정욱 on 6/25/25.
//

import Foundation
import StocksAPI

@main
struct StocksAPIExec {
    
    static func main() async {
        let stockService: StockServiceProtocol = StocksAPI.shared
        
        do {
            print("\n✅ Quotes 조회 테스트")
            let quotes = try await stockService.fetchQuotes(symbols: "AAPL,GOOG")
            print(quotes)
            
            print("\n✅ Ticker 검색 테스트")
            let tickers = try await stockService.searchTickers(query: "TSLA", isEquityTypeOnly: true)
            print(tickers)
            
            print("\n✅ Chart 조회 테스트")
            let chart = try await stockService.fetchChartData(tickerSymbol: "TSLA", range: .fiveYear)
            print(chart)
            
        } catch {
            print("\n❌ API 요청 실패: \(error.localizedDescription)")
        }
    }
}
