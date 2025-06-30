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
        do {
            print("\n✅ Quotes 조회 테스트")
            let quotes = try await QuoteService.shared.getQuotes(symbols: ["AAPL", "GOOG"])
            print(quotes)
            
            print("\n✅ Ticker Search 테스트")
            let tickers = try await TickerSearchService.shared.getTicker(query: "tesla")
            print(tickers)
            
            print("\n✅ Chart 데이터 테스트")
            let chart = try await ChartService.shared.getChart(symbol: "TSLA", range: .oneDay)
            print(chart)
            
        } catch {
            print("\n❌ API 호출 실패: \(error.localizedDescription)")
        }
    }
}
