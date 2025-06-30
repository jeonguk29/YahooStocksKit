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
        let stocksAPI = StocksAPI.shared
        
        do {
            print("\n✅ Quotes 조회 테스트")
            let quotes = try await stocksAPI.quoteService.getQuotes(symbols: ["AAPL", "GOOG"])
            print(quotes)
            
            print("\n✅ Ticker 검색 테스트")
            let tickers = try await stocksAPI.tickerSearchService.getTicker(query: "TSLA")
            print(tickers)
            
            print("\n✅ Chart 조회 테스트")
            let chart = try await stocksAPI.chartService.getChart(symbol: "TSLA", range: .fiveYear)
            print(chart)
            
        } catch {
            print("\n❌ API 요청 실패: \(error.localizedDescription)")
        }
    }
}
