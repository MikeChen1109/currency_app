//
//  ExchangeRateService.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Combine
import Foundation

class NetworkService: NetworkServiceProtocol {
    func requestData(with urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

class TestExchangeRateService: ExchangeRateServiceProtocol {
    var stubbedExchangeRate: ExchangeRateResponse?
    var fetchExchangeRateCalled = false
    
    func fetchExchangeRate() -> AnyPublisher<ExchangeRateResponse, Error> {
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "USD", rates: ["USD": 1.0])
        stubbedExchangeRate = exchangeRate

        if let exchangeRate = stubbedExchangeRate {
            return Just(exchangeRate)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    private let baseUrl = "https://openexchangerates.org/api/latest.json"
    private let appId = "a8f517c0f2f645b1ac089a59863438a0"
    private let thirtyMinutes: TimeInterval = 30 * 60
    
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchExchangeRate() -> AnyPublisher<ExchangeRateResponse, Error> {
        if checkTimestamp() {
            return storageService.retrieveExchangeRate()
//            if let exchangeRate = storageService.retrieveExchangeRate() {
//                return Just(exchangeRate)
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
        }
        
        let url = URL(string: "\(baseUrl)?app_id=\(appId)")!
        let urlRequest = URLRequest(url: url)
        
        return networkService.requestData(with: urlRequest)
            .decode(type: ExchangeRateResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { exchangeRate in
                self.storageService.saveExchangeRate(exchangeRate)
                self.storageService.saveTimestamp(Date())
            })
            .eraseToAnyPublisher()
    }
    
    private func checkTimestamp() -> Bool {
        if let timestamp = storageService.retrieveTimestamp() {
            return Date().timeIntervalSince(timestamp) < thirtyMinutes
        }
        return false
    }
}
