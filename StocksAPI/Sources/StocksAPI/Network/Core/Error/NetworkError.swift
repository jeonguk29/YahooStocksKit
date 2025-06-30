//
//  NetworkError.swift
//  StocksAPI
//
//  Created by 정정욱 on 6/30/25.
//

import Foundation

public enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case requestEncodingError
    case responseDecodingError
    case responseError
    case unknownError
    case loginFailed
    case notFoundError
    case notAllowedMethod
    case internalServerError
    case yahooAPIError(ErrorResponse)
    
    public var description: String {
        switch self {
        case .invalidURL: return "잘못된 URL입니다."
        case .requestEncodingError: return "요청 인코딩에 실패했습니다."
        case .responseDecodingError: return "응답 디코딩에 실패했습니다."
        case .responseError: return "응답 오류가 발생했습니다."
        case .unknownError: return "알 수 없는 오류가 발생했습니다."
        case .loginFailed: return "로그인에 실패하였습니다."
        case .notFoundError: return "요청한 자원을 찾을 수 없습니다."
        case .notAllowedMethod: return "지원하지 않는 HTTP 메서드입니다."
        case .internalServerError: return "서버 내부 오류가 발생했습니다."
        case .yahooAPIError(let error):
            return "야후 API 에러: \(error.code) - \(error.description)"
        }
    }
}
