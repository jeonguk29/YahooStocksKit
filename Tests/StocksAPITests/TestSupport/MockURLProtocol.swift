//
//  MockURLProtocol.swift
//  YahooStocksKit
//
//  Created by jeonguk29 on 9/1/25.
//

import Foundation

/// - 실제 통신 과정에서는 `Data`, `URLResponse`, `Error` 3가지를 반환하는데,
///   여기서는 그 역할을 우리가 직접 지정(mockResponse)한다.
final class MockURLProtocol: URLProtocol {
    
    /// 테스트에서 미리 세팅할 응답 (데이터, 응답 헤더/상태코드, 에러)
    /// 원래는 서버가 내려주는 값인데, 테스트에서는 우리가 직접 넣음
    static var mockResponse: (Data?, URLResponse?, Error?)?
    
    /// URLSession이 "이 요청을 내가 처리할 수 있냐?" 물어볼 때 호출됨.
    /// 여기선 어떤 요청이든(true) 내가 다 처리하겠다고 응답.
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    /// 실제 네트워크 요청이 시작될 때 호출됨.
    /// 원래라면 서버로 요청을 보내고 응답을 받아야 하지만,
    /// 여기선 mockResponse에 세팅된 값으로 가짜 통신을 흉내냄.
    override func startLoading() {
        if let (data, response, error) = MockURLProtocol.mockResponse {
            
            // (1) 에러가 세팅되어 있으면 → 요청 실패 전달
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            // (2) HTTP 응답 객체가 있으면 → 상태코드/헤더 전달
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            // (3) 데이터가 있으면 → body 데이터 전달
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // (4) 네트워크 작업이 끝났다고 URLSession에 알림
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
