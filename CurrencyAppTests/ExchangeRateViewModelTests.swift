//
//  ExchangeRateViewModelTests.swift
//  CurrencyAppTests
//
//  Created by 逸唐陳 on 2023/6/5.
//

import XCTest
import Combine
@testable import CurrencyApp

final class ExchangeRateViewModelTests: XCTestCase {
    
    private var sut: ExchangeRateViewModel!
    private var exchangeRateService: MockExchangeRateService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = .init()
        exchangeRateService = MockExchangeRateService()
        sut = ExchangeRateViewModel(exchangeRateService: exchangeRateService)
    }
    
    override func tearDown() {
        sut = nil
        exchangeRateService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testConversion_USD_100() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "USD", rates: ["USD": 1.0, "TWD": 30.0, "JPY": 100.0])
        let expectedExchangeRates: [RateModel] = [RateModel(currency: "JPY", rate: 10000.0),
                                                  RateModel(currency: "TWD", rate: 3000.0),
                                                  RateModel(currency: "USD", rate: 100.0)]
        var result = [RateModel]()
        let amount = 100.0
        let baseCurrency = "USD"
        exchangeRateService.stubbedExchangeRate = exchangeRate
    
        // Act
        let input = ExchangeRateViewModel.Input(
            baseCurrency: Just(baseCurrency).eraseToAnyPublisher(),
            amount: Just(amount).eraseToAnyPublisher()
        )
        
        let output = sut.transform(input: input)
        output.exchangeRates.sink { rates in
            result = rates
        }.store(in: &cancellables)
        
        // Assert
        XCTAssertEqual(result, expectedExchangeRates, "Exchange rate should match the stubbed value")
    }
    
    //test if the base currency is not USD
    func testConversion_TWD_100() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "TWD", rates: ["USD": 1.0, "TWD": 30.0, "JPY": 100.0])
        let expectedExchangeRates: [RateModel] = [RateModel(currency: "JPY", rate: 333.33333333333337),
                                                  RateModel(currency: "TWD", rate: 100.0),
                                                  RateModel(currency: "USD", rate: 3.3333333333333335)]
        var result = [RateModel]()
        let amount = 100.0
        let baseCurrency = "TWD"
        exchangeRateService.stubbedExchangeRate = exchangeRate
        
        // Act
        let input = ExchangeRateViewModel.Input(
            baseCurrency: Just(baseCurrency).eraseToAnyPublisher(),
            amount: Just(amount).eraseToAnyPublisher()
        )
        
        let output = sut.transform(input: input)
        output.exchangeRates.sink { rates in
            result = rates
        }.store(in: &cancellables)
        
        
        // Assert
        XCTAssertEqual(result, expectedExchangeRates, "Exchange rate should match the stubbed value")
    }
    
    // test if the base currency is not defined in the api
    func testConversion_BTC_100() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "TWD", rates: ["USD": 1.0, "TWD": 30.0, "JPY": 100.0])
        var result = [RateModel]()
        let amount = 100.0
        let baseCurrency = "BTC"
        exchangeRateService.stubbedExchangeRate = exchangeRate
        
        // Act
        let input = ExchangeRateViewModel.Input(
            baseCurrency: Just(baseCurrency).eraseToAnyPublisher(),
            amount: Just(amount).eraseToAnyPublisher()
        )
        
        let output = sut.transform(input: input)
        output.exchangeRates.sink { rates in
            result = rates
        }.store(in: &cancellables)
        
        // Assert
        XCTAssertTrue(result.isEmpty, "Exchange rate should be empty")
    }
    
    // test if the amount is 0
    func testConversion_USD_0() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "USD", rates: ["USD": 1.0, "TWD": 30.0, "JPY": 100.0])
        let expectedExchangeRates: [RateModel] = [RateModel(currency: "JPY", rate: 0.0),
                                                  RateModel(currency: "TWD", rate: 0.0),
                                                  RateModel(currency: "USD", rate: 0.0)]
        var result = [RateModel]()
        let amount = 0.0
        let baseCurrency = "USD"
        exchangeRateService.stubbedExchangeRate = exchangeRate
        
        // Act
        let input = ExchangeRateViewModel.Input(
            baseCurrency: Just(baseCurrency).eraseToAnyPublisher(),
            amount: Just(amount).eraseToAnyPublisher()
        )
        
        let output = sut.transform(input: input)
        output.exchangeRates.sink { rates in
            result = rates
        }.store(in: &cancellables)
        
        // Assert
        XCTAssertEqual(result, expectedExchangeRates, "Exchange rate should match the stubbed value")
    }
    
    
}
