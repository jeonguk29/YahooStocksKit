//
//  APIConfig.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public struct APIConfig {
    public let rapidapi_key: String
    public let rapidapi_host: String
    
    public init(rapidapi_key: String, rapidapi_host: String) {
        self.rapidapi_key = rapidapi_key
        self.rapidapi_host = rapidapi_host
    }
}

extension APIConfig {
    public static func load() -> APIConfig? {
        guard let infoDict = Bundle.main.infoDictionary else {
            print("⚠️ Info.plist를 불러올 수 없습니다.")
            return nil
        }

        guard let key = infoDict["RAPID_API_KEY"] as? String,
              let host = infoDict["RAPID_API_HOST"] as? String else {
            print("⚠️ Info.plist에 RAPID_API_KEY 또는 RAPID_API_HOST가 누락되었습니다.")
            return nil
        }

        return APIConfig(rapidapi_key: key, rapidapi_host: host)
    }
}
