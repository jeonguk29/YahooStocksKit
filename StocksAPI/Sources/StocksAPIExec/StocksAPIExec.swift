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

        let urlString = "https://yh-finance.p.rapidapi.com/market/v2/get-quotes?symbols=AAPL,GOOG"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(config.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }

            let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
            print(quoteResponse)

        } catch {
            print("Request failed: \(error)")
        }
    }
}
