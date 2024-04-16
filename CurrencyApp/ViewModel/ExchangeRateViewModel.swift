//
//  ExchangeRateViewModel.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine

struct ExchangeRateViewModel {
    
    struct Input {
        let baseCurrency: AnyPublisher<String, Never>
        let amount: AnyPublisher<Double, Never>
    }
    
    struct Output {
        let exchangeRates: AnyPublisher<[RateModel], Never>
    }
    
    private let exchangeRateService: ExchangeRateServiceProtocol
    
    init(exchangeRateService: ExchangeRateServiceProtocol) {
        self.exchangeRateService = exchangeRateService
    }
    
    func transform(input: Input) -> Output {
        let exchangeRates = input.baseCurrency
            .combineLatest(input.amount)
            .flatMap { baseCurrency, amount -> AnyPublisher<[RateModel], Never> in
                return self.exchangeRateService.fetchExchangeRate()
                    .map { exchangeRate -> [RateModel] in
                        self.convertCurrency(baseCurrency, exchangeRate.rates, amount)
                    }
                    .catch { error -> Just<[RateModel]> in
                        print(error)
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(exchangeRates: exchangeRates)
    }
    
    private func convertCurrency(_ baseCurrenct: String = "USD",
                                 _ originRates: [String: Double],
                                 _ amount: Double) -> [RateModel] {
        if let newBaseRate = originRates[baseCurrenct] {
            // Calculate the conversion factor from the new base currency to USD
            let conversionFactor = 1 / newBaseRate
            
            // Calculate the new exchange rates based on the new base currency
            var newExchangeRates: [String: Double] = [:]
            
            for (currency, rate) in originRates {
                newExchangeRates[currency] = (rate * conversionFactor) * amount
            }
            
            // Sort the exchange rates by currency code
            let sortedExchangeRates = newExchangeRates.sorted { $0.key < $1.key }
            let rates = sortedExchangeRates.map { RateModel(currency: $0.key, rate: $0.value) }
            
            return rates
        } else {
            print("Exchange rate for \(baseCurrenct) not found.")
            return []
        }
    }
    
}

