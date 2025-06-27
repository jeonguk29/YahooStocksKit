//
//  APIConfig.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/27/25.
//

import Foundation

public struct APIConfig: Codable {
    public let rapidapi_key: String
    public let rapidapi_host: String
}

extension APIConfig {
    public static func load() -> APIConfig? {
        let fileManager = FileManager.default
        let configPath = fileManager.currentDirectoryPath + "/APIConfig.json"

        guard let data = fileManager.contents(atPath: configPath) else {
            print("⚠️ APIConfig.json 파일을 찾을 수 없습니다. 경로: \(configPath)")
            return nil
        }

        do {
            let config = try JSONDecoder().decode(APIConfig.self, from: data)
            return config
        } catch {
            print("⚠️ APIConfig 디코딩 실패: \(error)")
            return nil
        }
    }
}
