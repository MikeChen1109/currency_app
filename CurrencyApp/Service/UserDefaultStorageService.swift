//
//  UserDefaultStorageService.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine

enum CustomError: Error {
    case convertFailure
    case noLocalData
}

class UserDefaultsStorageService: StorageServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func saveExchangeRate(_ exchangeRate: ExchangeRateResponse) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(exchangeRate) {
            userDefaults.set(encodedData, forKey: ExchangeRateKey)
        }
    }
    
    func retrieveExchangeRate() -> AnyPublisher<ExchangeRateResponse, Error> {
        let decoder = JSONDecoder()
        return userDefaults
            .object(forKey: ExchangeRateKey)
            .publisher
            .tryMap { anyObject in
                guard let data = anyObject as? Data else {
                    throw CustomError.noLocalData
                }
                guard let response = try? decoder.decode(ExchangeRateResponse.self, from: data) else {
                    throw CustomError.convertFailure
                }
                return response
            }
            .eraseToAnyPublisher()
    }
//
//    func retrieveExchangeRate() -> ExchangeRateResponse? {
//        let decoder = JSONDecoder()
//        if let data = userDefaults.object(forKey: ExchangeRateKey) as? Data,
//           let exchangeRate = try? decoder.decode(ExchangeRateResponse.self, from: data) {
//            return exchangeRate
//        }
//        return nil
//    }
    
    func saveTimestamp(_ timestamp: Date) {
        userDefaults.set(timestamp, forKey: TimestampKey)
    }
    
    func retrieveTimestamp() -> Date? {
        return userDefaults.object(forKey: TimestampKey) as? Date
    }
}
