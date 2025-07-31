//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

// https://yh-finance.p.rapidapi.com/stock/v3/get-chart?interval=1mo&symbol=AMRN&range=5y&region=US&includePrePost=false&useYfid=true&includeAdjustedClose=true&events=capitalGain%2Cdiv%2Csplit

// MARK: - 최상위 차트 응답
public struct ChartResponse: Decodable {
    
    /// 차트 데이터 (기간별 시세 정보들)
    public let data: [ChartData]?
    
    /// API 에러 정보
    let error: ErrorResponse?
    
    enum RootKeys: String, CodingKey {
        case chart
    }
    
    enum ChartKeys: String, CodingKey {
        case result
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        if let chartContainer = try? rootContainer.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
            data = try chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
            error = try chartContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else {
            data = nil
            error = nil
        }
    }
}

// MARK: - 차트 내부 데이터 (종목별 시세 + 메타데이터)
public struct ChartData: Decodable {
    
    /// 메타정보 (심볼명, 통화, 거래소명 등)
    public let metadata: Metadata
    
    /// 구간별 시세 정보 리스트 (open/high/low/close)
    public let indicators: [Indicator]
    
    // MARK: - 메타데이터 구조체
    public struct Metadata: Decodable {
        
        /// 거래통화 (예: "USD")
        public let currency: String
        
        /// 심볼명 (예: "TSLA")
        public let symbol: String
        
        /// 현재 시점의 시장가
        public let regularMarketPrice: Double?
        
        /// 전일 종가
        public let previousClose: Double?
        
        /// GMT 오프셋 (초 단위 / 예: -14400초 = 뉴욕 -4시간)
        public let gmtOffset: Int
        
        /// 정규장 시작 시간 (Unix Timestamp → Date 변환됨)
        public let regularTradingPeriodStartDate: Date
        
        /// 정규장 종료 시간 (Unix Timestamp → Date 변환됨)
        public let regularTradingPeriodEndDate: Date
        
        enum RootKeys: String, CodingKey {
            case currency
            case symbol
            case regularMarketPrice
            case currentTradingPeriod
            case previousClose
            case gmtOffset = "gmtoffset"
        }
        
        enum RootTradingPeriodKeys: String, CodingKey {
            case pre
            case regular
            case post
        }
        
        enum TradingPeriodKeys: String, CodingKey {
            case start
            case end
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)
            self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
            self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
            self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
            self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
            self.gmtOffset = try container.decodeIfPresent(Int.self, forKey: .gmtOffset) ?? 0
            
            // currentTradingPeriod > regular > start, end
            let rootTradingPeriodContainer = try? container.nestedContainer(keyedBy: RootTradingPeriodKeys.self, forKey: .currentTradingPeriod)
            let regularTradingPeriodContainer = try? rootTradingPeriodContainer?.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regular)
            
            self.regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .start) ?? Date()
            self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .end) ?? Date()
        }
    }
    
    // MARK: - 각 날짜별 시세 정보 (OHLC)
    public struct Indicator: Decodable {
        
        /// 해당 시점 (timestamp → Date 변환됨)
        public let timestamp: Date
        
        /// 시가 (Open Price)
        public let open: Double
        
        /// 고가 (High Price)
        public let high: Double
        
        /// 저가 (Low Price)
        public let low: Double
        
        /// 종가 (Close Price)
        public let close: Double
    }
    
    enum RootKeys: String, CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorsKeys: String, CodingKey {
        case quote
    }
    
    enum QuoteKeys: String, CodingKey {
        case high
        case close
        case low
        case open
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        /// 메타데이터 디코딩
        metadata = try container.decode(Metadata.self, forKey: .meta)
        
        /// 시점 데이터 (Unix timestamp 배열)
        let timestampsInt = try container.decodeIfPresent([Int].self, forKey: .timestamp) ?? []
        let timestamps = timestampsInt.map { Date(timeIntervalSince1970: TimeInterval($0)) }
        
        if let indicatorContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {
            
            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            
            // 시점별 OHLC 데이터 배열화
            indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard
                    let open = opens[offset],
                    let low = lows[offset],
                    let close = closes[offset],
                    let high = highs[offset]
                else { return nil}
                return .init(timestamp: timestamp, open: open, high: high, low: low, close: close)
            }
        } else {
            self.indicators = []
        }
    }
}
