//
//  APIService.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public protocol APIRequestable {
    func request<T: Decodable>(
        endpoint: EndpointItem,
        responseType: T.Type
    ) async throws -> T
}

public final class APIService: APIRequestable {
    private let baseURL: String
    private let config: APIConfig
    private let session: URLSession
    
    public init(
        baseURL: String = "https://yh-finance.p.rapidapi.com",
        config: APIConfig,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.config = config
        self.session = session
    }
    
    public func request<T: Decodable>(
        endpoint: EndpointItem,
        responseType: T.Type
    ) async throws -> T {
        // URL 생성
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        // 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(config.rapidapi_host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(config.rapidapi_key, forHTTPHeaderField: "x-rapidapi-key")
        
        // 네트워크 호출
        let (data, response) = try await session.data(for: request)
        
        // 응답 검증
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        
        // 상태코드 에러 처리
        guard (200...299).contains(httpResponse.statusCode) else {
            throw configureHTTPError(errorCode: httpResponse.statusCode, data: data)
        }
        
        // 성공 응답 디코딩
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.responseDecodingError
        }
    }
    
    // MARK: - 상태 코드 매핑 함수
    private func configureHTTPError(errorCode: Int, data: Data?) -> Error {
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
            // 서버가 내려준 에러 응답(JSON) 파싱 시도
            if let data,
               let errResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                return NetworkError.yahooAPIError(errResponse)
            }
            return NetworkError.unknownError
        }
    }
}
