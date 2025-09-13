//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public final class QuoteService {
    
    private let apiService: APIRequestable
    
    public init(apiService: APIRequestable) {
        self.apiService = apiService
    }
    
    public func fetchQuotes(symbols: String) async throws -> [Quote] {
        let endpoint = Endpoint.YahooFinance.getQuotes(symbols: symbols).endpointItem
        
        let response = try await apiService.request(
            endpoint: endpoint,
            responseType: QuoteResponse.self
        )
        
        return response.data ?? []
    }
}
