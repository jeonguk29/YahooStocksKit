//
//  Test.swift
//  YahooStocksKit
//
//  Created by jeonguk29 on 9/1/25.
//

import Testing
import Foundation
@testable import StocksAPI

// MARK: - Endpoint 테스트
struct EndpointTests {
    @Test("pathWithQuery가 올바르게 조합된다")
    func pathWithQuery생성() {
        let item = EndpointItem(
            path: "/market/v2/get-quotes",
            method: .GET,
            queryItems: [URLQueryItem(name: "symbols", value: "AAPL,MSFT")]
        )
        #expect(item.pathWithQuery == "/market/v2/get-quotes?symbols=AAPL,MSFT")
    }
    
    @Test("getQuotes Endpoint가 올바른 쿼리를 생성한다")
    func getQuotesEndpoint() {
        let endpoint = Endpoint.YahooFinance.getQuotes(symbols: "AAPL,MSFT").endpointItem
        #expect(endpoint.pathWithQuery == "/market/v2/get-quotes?symbols=AAPL,MSFT")
    }
}

// MARK: - NetworkError 테스트
struct NetworkErrorTests {
    @Test("invalidURL은 올바른 description을 반환한다")
    func invalidURL() {
        let error = NetworkError.invalidURL
        #expect(error.description == "잘못된 URL입니다.")
    }
    
    @Test("yahooAPIError는 ErrorResponse 내용을 포함한다")
    ///실제 Yahoo API는 에러가 나면 JSON 안에 code, description을 반환
    func yahooAPIError() {
        let response = ErrorResponse(code: "400", description: "Bad Request")
        let error = NetworkError.yahooAPIError(response)
        #expect(error.description == "야후 API 에러: 400 - Bad Request")
    }
}

// MARK: - APIService 테스트 (Mock URLProtocol 사용)
struct APIServiceTests {
    private func makeAPIService() -> APIService {
        let config = APIConfig(rapidapi_key: "test-key", rapidapi_host: "test-host")
        let configSession = URLSessionConfiguration.ephemeral
        configSession.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configSession)
        return APIService(config: config, session: session)
    }
    
    @Test("정상 응답은 모델로 디코딩된다")
    func successResponse() async throws {
        defer { MockURLProtocol.mockResponse = nil }
        let json = """
        {
          "quoteResponse": {
            "result": [
              { "symbol": "AAPL" }
            ],
            "error": null
          }
        }
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.mockResponse = (json, response, nil)
        
        let apiService = makeAPIService()
        let endpoint = EndpointItem(path: "/get-quotes", method: .GET, queryItems: [])
        let result: QuoteResponse = try await apiService.request(endpoint: endpoint, responseType: QuoteResponse.self)
        
        #expect(result.data?.first?.symbol == "AAPL")
    }
    
    @Test("404 응답은 notFoundError를 반환한다")
    func notFoundErrorResponse() async {
        defer { MockURLProtocol.mockResponse = nil }
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                       statusCode: 404, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (nil, response, nil)
        
        let apiService = makeAPIService()
        let endpoint = EndpointItem(path: "/not-found", method: .GET, queryItems: [])
        
        await #expect(throws: NetworkError.notFoundError) {
            let _: QuoteResponse = try await apiService.request(endpoint: endpoint, responseType: QuoteResponse.self)
        }
    }
}
