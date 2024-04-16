//
//  ExchangeRate.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation

struct ExchangeRateResponse: Codable, Equatable {
    let disclaimer: String
    let license: String
    let timestamp: TimeInterval
    let base: String
    let rates: [String: Double]
    
    // equatable
    static func == (lhs: ExchangeRateResponse, rhs: ExchangeRateResponse) -> Bool {
        return lhs.disclaimer == rhs.disclaimer &&
            lhs.license == rhs.license &&
            lhs.timestamp == rhs.timestamp &&
            lhs.base == rhs.base &&
            lhs.rates == rhs.rates
    }
}
