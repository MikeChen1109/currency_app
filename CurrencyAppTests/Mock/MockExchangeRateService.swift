//
//  MockExchangeRateService.swift
//  CurrencyAppTests
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine
@testable import CurrencyApp

class MockExchangeRateService: ExchangeRateServiceProtocol {
    var stubbedExchangeRate: ExchangeRateResponse?
    var fetchExchangeRateCalled = false
    
    func fetchExchangeRate() -> AnyPublisher<ExchangeRateResponse, Error> {
        fetchExchangeRateCalled = true
        
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
