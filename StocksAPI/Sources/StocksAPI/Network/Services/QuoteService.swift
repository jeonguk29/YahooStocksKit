//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class QuoteService {
    
    public static let shared = QuoteService()
    
    private init() {}
    
    public func getQuotes(symbols: [String]) async throws -> QuoteResponse {
        let symbolsQuery = symbols.joined(separator: ",")
        
        let endpoint = Endpoint.YahooFinance.getQuotes(symbols: symbolsQuery).endpointItem
        
        return try await APIService.shared.request(
            path: endpoint.pathWithQuery,
            method: endpoint.method,
            responseType: QuoteResponse.self
        )
    }
}
