//
//  File.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public enum ChartRange: String {
    
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case ytd = "ytd"
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max = "max"
    
    var interval: String {
        switch self {
        case .oneDay: return "1m"
        case .oneWeek: return "5m"
        case .oneMonth: return "90m"
        case .threeMonth, .sixMonth, .ytd, .oneYear, .twoYear: return "1d"
        case .fiveYear, .tenYear: return "1wk"
        case .max: return "3mo"
        }
    }
}
