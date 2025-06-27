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
        guard let config = APIConfig.load() else {
            print("❌ API 설정 로드 실패")
            return
        }

        let quoteService = QuoteService(config: config)
        let tickerService = TickerSearchService(config: config)

        do {
            //let quotes = try await quoteService.fetchQuotes(symbols: ["AAPL", "GOOG"])
            //print(quotes)

            let tslaQuote = try await tickerService.fetchTicker(symbol: "TSLA")
            print(tslaQuote)
        } catch {
            print("❌ API 요청 실패: \(error)")
        }
    }
}
