//
//  Quote.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/25/25.
//

import Foundation


// https://yh-finance.p.rapidapi.com/market/v2/get-quotes?symbols=GOOG

public struct QuoteResponse: Decodable {
    
    let data: [Quote]?
    let error: ErrorResponse?
    
    enum RootKeys: String, CodingKey {
        case quoteResponse
    }
    
    enum QuoteResponseKeys: String, CodingKey {
        case result
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        if let quoteResponseContainer = try? container.nestedContainer(keyedBy: QuoteResponseKeys.self, forKey: .quoteResponse) {
            self.data = try quoteResponseContainer.decodeIfPresent([Quote].self, forKey: .result)
            self.error = try quoteResponseContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else {
            self.data = nil
            self.error = nil
        }
    }
}

public struct Quote: Decodable, Identifiable, Hashable {
    
    public let id = UUID()
    
    public let currency: String?
    public let marketState: String?
    public let fullExchangeName: String?
    public let displayName: String?
    public let symbol: String?
    
    public let regularMarketPrice: Double?
    public let regularMarketChange: Double?
    public let regularMarketChangePercent: Double?
    public let regularMarketChangePreviousClose: Double?
    
    public let postMarketPrice: Double?
    public let postMarketPriceChange: Double?
    
    public let regularMarketOpen: Double?
    public let regularMarketDayHigh: Double?
    public let regularMarketDayLow: Double?
    
    public let regularMarketVolume: Double?
    public let trailingPE: Double?
    public let marketCap: Double?
    
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let averageDailyVolume3Month: Double?
    
    public let trailingAnnualDividendYield: Double?
    public let epsTrailingTwelveMonths: Double?
    
    enum CodingKeys: String, CodingKey {
        case currency
        case marketState
        case fullExchangeName
        case displayName
        case symbol
        
        case regularMarketPrice
        case regularMarketChange
        case regularMarketChangePercent
        case regularMarketChangePreviousClose
        
        case postMarketPrice
        case postMarketPriceChange
        
        case regularMarketOpen
        case regularMarketDayHigh
        case regularMarketDayLow
        
        case regularMarketVolume
        case trailingPE
        case marketCap
        
        case fiftyTwoWeekLow
        case fiftyTwoWeekHigh
        case averageDailyVolume3Month
        
        case trailingAnnualDividendYield
        case epsTrailingTwelveMonths
    }
    
    public init(currency: String?, marketState: String?, fullExchangeName: String?, displayName: String?, symbol: String?, regularMarketPrice: Double?, regularMarketChange: Double?, regularMarketChangePercent: Double?, regularMarketChangePreviousClose: Double?, postMarketPrice: Double?, postMarketPriceChange: Double?, regularMarketOpen: Double?, regularMarketDayHigh: Double?, regularMarketDayLow: Double?, regularMarketVolume: Double?, trailingPE: Double?, marketCap: Double?, fiftyTwoWeekLow: Double?, fiftyTwoWeekHigh: Double?, averageDailyVolume3Month: Double?, trailingAnnualDividendYield: Double?, epsTrailingTwelveMonths: Double?) {
        self.currency = currency
        self.marketState = marketState
        self.fullExchangeName = fullExchangeName
        self.displayName = displayName
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketChangePreviousClose = regularMarketChangePreviousClose
        self.postMarketPrice = postMarketPrice
        self.postMarketPriceChange = postMarketPriceChange
        self.regularMarketOpen = regularMarketOpen
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.trailingPE = trailingPE
        self.marketCap = marketCap
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
    }
}
