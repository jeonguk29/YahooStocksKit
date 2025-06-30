//
//  APIService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private let baseURL: String = "https://yh-finance.p.rapidapi.com"
    private let config: APIConfig?
    
    private init() {
        guard let loadedConfig = APIConfig.load() else {
            fatalError("❌ API 설정 로드 실패")
        }
        self.config = loadedConfig
    }
    
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String : String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(config?.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config?.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")
        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw configureHTTPError(errorCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            print("❌ DecodingError: \(decodingError)")
            throw NetworkError.responseDecodingError
        } catch {
            print("❌ 일반 에러: \(error)")
            throw NetworkError.responseDecodingError
        }
    }
    
    private func configureHTTPError(errorCode: Int) -> Error {
        switch errorCode {
        case 400:
            return NetworkError.loginFailed
        case 404:
            return NetworkError.notFoundError
        case 405:
            return NetworkError.notAllowedMethod
        case 500:
            return NetworkError.internalServerError
        default:
            return NetworkError.unknownError
        }
    }
}
