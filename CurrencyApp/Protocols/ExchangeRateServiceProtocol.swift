//
//  ExchangeRateServiceProtocol.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine

protocol ExchangeRateServiceProtocol {
    func fetchExchangeRate() -> AnyPublisher<ExchangeRateResponse, Error>
}
