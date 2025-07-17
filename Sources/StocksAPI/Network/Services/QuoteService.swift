//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class QuoteService {
    
    public static let shared = QuoteService()
    
    public init() {}
    
    public func fetchQuotes(symbols: String) async throws -> [Quote] {
        let endpoint = Endpoint.YahooFinance.getQuotes(symbols: symbols).endpointItem
        
        let response = try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
            responseType: QuoteResponse.self
        )
        
        return response.data ?? []
    }
}
