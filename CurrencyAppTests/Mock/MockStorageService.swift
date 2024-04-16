//
//  MockStorageService.swift
//  CurrencyAppTests
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine
@testable import CurrencyApp

class MockStorageService: StorageServiceProtocol {
    var retrieveDataCalled = false
    var savedExchangeRate: ExchangeRateResponse?
    var savedTimestamp: Date?

    func saveExchangeRate(_ exchangeRate: ExchangeRateResponse) {
        savedExchangeRate = exchangeRate
    }

//    func retrieveExchangeRate() -> ExchangeRateResponse? {
//        retrieveDataCalled = true
//        return savedExchangeRate
//    }
    
    func retrieveExchangeRate() -> AnyPublisher<CurrencyApp.ExchangeRateResponse, Error> {
        retrieveDataCalled = true
        return Just(savedExchangeRate!).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func saveTimestamp(_ timestamp: Date) {
        savedTimestamp = timestamp
    }

    func retrieveTimestamp() -> Date? {
        return savedTimestamp
    }
}
