//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

/// 최종 URL Path + QueryString을 조립하기 위한 구조체
public struct EndpointItem {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]

    /// 쿼리까지 포함된 최종 경로 문자열
    var pathWithQuery: String {
        guard !queryItems.isEmpty else { return path }
        let queryString = queryItems
            .map { "\($0.name)=\($0.value ?? "")" }
            .joined(separator: "&")
        return "\(path)?\(queryString)"
    }
}

enum Endpoint {
    
    // MARK: - YahooFinance API
    enum YahooFinance {
        
        case getChart(symbol: String, range: String, interval: String, region: String, includePrePost: Bool, useYfid: Bool, includeAdjustedClose: Bool, events: String)
        case getQuotes(symbols: String)
        case searchTicker(region: String, query: String)
        
        /// HTTP 메서드
        var method: HTTPMethod {
            switch self {
            case .getChart, .getQuotes, .searchTicker:
                return .GET
            }
        }
        
        /// URL Path
        var path: String {
            switch self {
            case .getChart:
                return "/stock/v3/get-chart"
            case .getQuotes:
                return "/market/v2/get-quotes"
            case .searchTicker:
                return "/auto-complete"
            }
        }
        
        /// URL Query Items
        var queryItems: [URLQueryItem] {
            switch self {
            case let .getChart(symbol, range, interval, region, includePrePost, useYfid, includeAdjustedClose, events):
                return [
                    URLQueryItem(name: "symbol", value: symbol),
                    URLQueryItem(name: "range", value: range),
                    URLQueryItem(name: "interval", value: interval),
                    URLQueryItem(name: "region", value: region),
                    URLQueryItem(name: "includePrePost", value: "\(includePrePost)"),
                    URLQueryItem(name: "useYfid", value: "\(useYfid)"),
                    URLQueryItem(name: "includeAdjustedClose", value: "\(includeAdjustedClose)"),
                    URLQueryItem(name: "events", value: events)
                ]
                
            case let .getQuotes(symbols):
                return [
                    URLQueryItem(name: "symbols", value: symbols)
                ]
                
            case let .searchTicker(region, query):
                return [
                    URLQueryItem(name: "region", value: region),
                    URLQueryItem(name: "q", value: query)
                ]
            }
        }
        
        /// 최종 EndpointItem 반환 (APIService에서 사용)
        var endpointItem: EndpointItem {
            EndpointItem(
                path: self.path,
                method: self.method,
                queryItems: self.queryItems
            )
        }
    }
}
