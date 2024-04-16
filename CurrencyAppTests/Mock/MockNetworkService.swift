//
//  MockNetworkService.swift
//  CurrencyAppTests
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine
@testable import CurrencyApp

class MockNetworkService: NetworkServiceProtocol {
    var requestDataCalled = false
    var stubbedExchangeRate: ExchangeRateResponse?
    var stubbedError: Error?

    func requestData(with urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        requestDataCalled = true

        if let exchangeRate = stubbedExchangeRate {
            return Just(try! JSONEncoder().encode(exchangeRate))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            fatalError("No stubbed exchange rate or error provided.")
        }
    }
}
