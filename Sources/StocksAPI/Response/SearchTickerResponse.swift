//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

// https://yh-finance.p.rapidapi.com/auto-complete?region=US&q=tesla
public struct SearchTickerResponse: Decodable {
    
    public let error: ErrorResponse?
    public let data: [Ticker]?
    
    enum RootKeys: String, CodingKey {
        case count
        case quotes
        case finance
    }
    
    enum FinanceKeys: String, CodingKey {
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        data = try container.decodeIfPresent([Ticker].self, forKey: .quotes)
        error = try? container.nestedContainer(keyedBy: FinanceKeys.self, forKey: .finance)
            .decodeIfPresent(ErrorResponse.self, forKey: .error)
    }
}

public struct Ticker: Decodable, Identifiable, Hashable {
    public let id = UUID()
    
    public let symbol: String
    public let shortname: String?
    public let longname: String?
    public let quoteType: String?
    public let exchDisp: String?
    public let sector: String?
    public let industry: String?
    
    public enum CodingKeys: String, CodingKey {
        case symbol, shortname, longname, quoteType, exchDisp, sector, industry
    }
    
    public init(symbol: String, shortname: String?, longname: String?, quoteType: String?, exchDisp: String?, sector: String?, industry: String?) {
        self.symbol = symbol
        self.shortname = shortname
        self.longname = longname
        self.quoteType = quoteType
        self.exchDisp = exchDisp
        self.sector = sector
        self.industry = industry
    }
}

extension Ticker {
    /// Stub 용 간단 생성자
    public init(symbol: String, shortname: String) {
        self.symbol = symbol
        self.shortname = shortname
        self.longname = nil
        self.quoteType = nil
        self.exchDisp = nil
        self.sector = nil
        self.industry = nil
    }
}

