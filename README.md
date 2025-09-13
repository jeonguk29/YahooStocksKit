##  YahooStocksKit

**YahooStocksKit**은 [RapidAPI의 Yahoo Finance API](https://rapidapi.com/apidojo/api/yahoo-finance1/)를 기반으로 주식 정보를 조회할 수 있도록 구성된 Swift Package입니다. 해당 링크로 접속해서 개인 API Key를 발급 하여 교체 해주세요.


StocksAPI는 Facade 패턴처럼 외부(App)에서 사용하기 쉽게 서비스들의 진입점을 제공하고 있어요.

내부적으로는 QuoteService, ChartService, TickerSearchService에 의존성을 주입해서 네트워크 계층을 분리했습니다.

싱글톤(shared)을 제공해 앱단에서 쉽게 쓰도록 했지만, 동시에 init(apiService:)를 공개해서 테스트나 다른 환경에서는 DI(의존성 주입) 기반으로 교체 가능하게 설계했어요.

모듈화된 구조와 비동기 `async/await` 기반 네트워크 처리를 통해 간결하고 직관적인 API 사용을 지향합니다.


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
        let stocksAPI = StocksAPI.shared   // Facade 진입점
        
        do {
            print("\n 📈 Quotes 조회 테스트")
            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAPL,GOOG")
            print(quotes)
            
            print("\n 🔍 Ticker 검색 테스트")
            let tickers = try await stocksAPI.searchTickers(query: "TSLA", isEquityTypeOnly: true)
            print(tickers)
            
            print("\n 🪧 Chart 조회 테스트")
            let chart = try await stocksAPI.fetchChartData(tickerSymbol: "TSLA", range: .fiveYear)
            print(chart)
            
        } catch {
            print("\n❌ API 요청 실패: \(error.localizedDescription)")
        }
    }
}

```

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

## 주요 기능

| 서비스             | 설명                     |
| --------------- | ---------------------- |
| `QuoteService`  | 특정 티커(예: AAPL)의 현재가 조회 |
| `ChartService`  | 기간별 차트 데이터 조회          |
| `TickerService` | 티커 검색/자동완성 기능 지원       |



---

## 단위 테스트 

**YahooStocksKit**은 단순히 API 연결만 제공하는 게 아니라, 테스트 가능성(Testability)을 고려한 구조로 설계되었습니다. `DI(의존성 주입)` 기반으로 `APIService`를 교체할 수 있도록 만들었기 때문에,
실제 API 서버가 없어도 Mock 환경에서 네트워크 요청을 흉내내며 단위 테스트가 가능합니다.

<img width="609" height="822" alt="image" src="https://github.com/user-attachments/assets/80632498-4db1-4f10-b46d-8b301d043f81" />


### 1. Core 계층 테스트

* `EndpointTests`: Endpoint가 올바른 쿼리를 생성하는지 검증
* `NetworkErrorTests`: 각 에러 케이스가 올바른 메시지를 반환하는지 검증
* `APIServiceTests`: `MockURLProtocol`을 사용해 **200 응답 → 정상 디코딩**, **404 응답 → notFoundError 발생** 시나리오 검증

```swift
@Test("정상 응답은 모델로 디코딩된다")
func successResponse() async throws {
    defer { MockURLProtocol.mockResponse = nil }
    let json = """
    { "quoteResponse": { "result": [ { "symbol": "AAPL" } ], "error": null } }
    """.data(using: .utf8)!

    let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                   statusCode: 200, httpVersion: nil, headerFields: nil)!
    MockURLProtocol.mockResponse = (json, response, nil)

    let apiService = APIService.makeMocked()
    let endpoint = EndpointItem(path: "/get-quotes", method: .GET, queryItems: [])
    let result: QuoteResponse = try await apiService.request(endpoint: endpoint, responseType: QuoteResponse.self)

    #expect(result.data?.first?.symbol == "AAPL")
}
```

---

### 2. Service 계층 테스트

* `QuoteServiceTests`: 특정 종목(AAPL)의 시세 정보가 정상적으로 디코딩되는지 검증
* `TickerSearchServiceTests`: 티커 검색 결과가 올바르게 파싱되는지 검증
* `ChartServiceTests`: 차트 데이터에서 메타데이터/인디케이터가 정상적으로 매핑되는지 검증

```swift
@Test("QuoteService가 정상 응답을 디코딩한다")
func fetchQuotesSuccess() async throws {
    defer { MockURLProtocol.mockResponse = nil }
    let json = """
    { "quoteResponse": { "result": [ { "symbol": "AAPL" } ], "error": null } }
    """.data(using: .utf8)!

    let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                   statusCode: 200, httpVersion: nil, headerFields: nil)!
    MockURLProtocol.mockResponse = (json, response, nil)

    let service = QuoteService(apiService: APIService.makeMocked())
    let quotes = try await service.fetchQuotes(symbols: "AAPL")

    #expect(quotes.first?.symbol == "AAPL")
}
```

---

### 3. Repository 계층 테스트

* `RepositoryTests`: 실제 API 호출 대신 `MockStockRepository`를 사용하여,
  Repository 계층이 올바르게 동작하는지 독립적으로 검증

```swift
@Test("MockRepository를 통해 종목 검색이 정상 동작한다")
func searchTickers() async throws {
    let mockRepo = MockStockRepository()
    mockRepo.mockTickers = [Ticker(symbol: "AAPL", shortname: "Apple")]

    let result = try await mockRepo.searchTickers(query: "AAPL", isEquityTypeOnly: true)

    #expect(result.count == 1)
    #expect(result.first?.symbol == "AAPL")
}
```


---

## ⚠️ 주의사항

- `APIConfig`는 앱 타겟의 `Info.plist`에 `rapidapi_key` 및 `rapidapi_host`를 명시해야 정상 동작합니다.
- 이 라이브러리는 API Key를 직접 포함하지 않습니다.

---


