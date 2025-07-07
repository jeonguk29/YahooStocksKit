## 📘 YahooStocksKit

**YahooStocksKit**은 [RapidAPI의 Yahoo Finance API](https://rapidapi.com/apidojo/api/yahoo-finance1/)를 기반으로 주식 정보를 조회할 수 있도록 구성된 Swift Package입니다.\
모듈화된 구조와 비동기 `async/await` 기반 네트워크 처리를 통해 간결하고 직관적인 API 사용을 지향합니다.
해당 링크로 접속해서 개인 API Key를 발급 하시길 바랍니다.

---

## 🗂️ 구조

```
YahooStocksKit
├── Resources
│   └── (SPM 패키지 자체에서 사용하지 않음 내부 테스트용)
├── Sources
│   └── StocksAPI
│       ├── Network
│       │   ├── Core
│       │   │   ├── APIConfig        // Info.plist에서 API 키/호스트 로드
│       │   │   ├── APIService       // 공통 API 호출 처리
│       │   │   ├── Endpoint         // URL path 정의
│       │   │   ├── HTTPMethod       // GET, POST 등 HTTP 메서드 enum
│       │   │   └── Error            // 커스텀 에러 타입들
│       │   └── Services
│       │       ├── ChartService     // 차트 데이터 요청 처리
│       │       ├── QuoteService     // 종목 현재가 정보 요청 처리
│       │       └── TickerService    // 티커 검색/조회 요청 처리
│       ├── Response                 // API 응답 모델
│       └── StocksAPI                // 외부 노출용 진입점 (Facade 역할)
├── StocksAPIExec
│   └── StocksAPIExec               // 실행/테스트 용도 모듈
```

---

## 🚀 사용법

### 1. Info.plist에 RapidAPI 키 설정

```xml
<key>RAPID_API_KEY</key>
<string>YOUR_RAPID_API_KEY</string>
<key>RAPID_API_HOST</key>
<string>yh-finance.p.rapidapi.com</string>
```
해당 SPM을 설치하고 프로젝트에 Info.plist에 다음과 같이 작성을 부탁드립니다.
<img width="1015" alt="image" src="https://github.com/user-attachments/assets/07bcf044-d99e-485f-bddf-4e57f4dc9c21" />


### 2. 서비스 사용 예시

```swift
@main
struct StocksAPIExec {
    
    static func main() async {
        let stocksAPI = StocksAPI.shared
        
        do {
            print("\n Quotes 조회 테스트")
            let quotes = try await stocksAPI.quoteService.getQuotes(symbols: ["AAPL", "GOOG"])
            print(quotes)
            
            print("\n Ticker 검색 테스트")
            let tickers = try await stocksAPI.tickerSearchService.getTicker(query: "TSLA")
            print(tickers)
            
            print("\n Chart 조회 테스트")
            let chart = try await stocksAPI.chartService.getChart(symbol: "TSLA", range: .fiveYear)
            print(chart)
            
        } catch {
            print("\n❌ API 요청 실패: \(error.localizedDescription)")
        }
    }
}

```

---

## 🧩 주요 기능

| 서비스             | 설명                     |
| --------------- | ---------------------- |
| `QuoteService`  | 특정 티커(예: AAPL)의 현재가 조회 |
| `ChartService`  | 기간별 차트 데이터 조회          |
| `TickerService` | 티커 검색/자동완성 기능 지원       |

---

## 🧱 기술 스택

- Swift 5.9+
- Swift Package Manager (SPM)
- `async/await` 기반 `URLSession`
- `Codable` 기반 모델링
- 모듈화 및 SOLID 설계

---

## ⚠️ 주의사항

- `APIConfig`는 앱 타겟의 `Info.plist`에 `rapidapi_key` 및 `rapidapi_host`를 명시해야 정상 동작합니다.
- 이 라이브러리는 API Key를 직접 포함하지 않습니다.

---


