//
//  ExchangeRateServiceTest.swift
//  CurrencyAppTests
//
//  Created by 逸唐陳 on 2023/6/5.
//

import XCTest
import Combine
@testable import CurrencyApp

final class ExchangeRateServiceTest: XCTestCase {

    private var networkService: MockNetworkService!
    private var storageService: MockStorageService!
    private var sut: ExchangeRateService!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        storageService = MockStorageService()
        sut = ExchangeRateService(networkService: networkService, storageService: storageService)
    }

    override func tearDown() {
        networkService = nil
        storageService = nil
        sut = nil
        super.tearDown()
    }

    func testFetchExchangeRate_WhenTimestampWithinThirtyMinutes_ReturnsSavedExchangeRate() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "USD", rates: ["USD": 1.0])
        let timestamp = Date().addingTimeInterval(-29 * 60) // Within 30 minutes

        setupStubbedExchangeRate(exchangeRate, timestamp: timestamp)

        // Act
        var receivedExchangeRate: ExchangeRateResponse?

        let cancellable = sut.fetchExchangeRate()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { exchangeRate in
                    receivedExchangeRate = exchangeRate
                }
            )

        cancellable.cancel()

        // Assert
        XCTAssertFalse(networkService.requestDataCalled, "requestData shouldn't be called")
        XCTAssertTrue(storageService.retrieveDataCalled, "retrieveDataCalled should be called")
        XCTAssertEqual(receivedExchangeRate, exchangeRate, "Received exchange rate should match the stubbed value")
    }

    func testFetchExchangeRate_WhenTimestampExpired_MakesNetworkRequestAndSavesData() {
        // Arrange
        let exchangeRate = ExchangeRateResponse(disclaimer: "", license: "", timestamp: 123, base: "USD", rates: ["USD": 1.0])

        setupStubbedExchangeRate(exchangeRate, timestamp: nil)

        // Act
        var receivedExchangeRate: ExchangeRateResponse?

        let cancellable = sut.fetchExchangeRate()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { exchangeRate in
                    receivedExchangeRate = exchangeRate
                }
            )

        cancellable.cancel()

        // Assert
        XCTAssertFalse(storageService.retrieveDataCalled, "retrieveDataCalled shouldn't be called")
        XCTAssertTrue(networkService.requestDataCalled, "requestData should be called")
        XCTAssertEqual(receivedExchangeRate, exchangeRate, "Received exchange rate should match the stubbed value")
        XCTAssertEqual(storageService.savedExchangeRate, exchangeRate, "Exchange rate should be saved")
        XCTAssertNotNil(storageService.savedTimestamp, "Timestamp should be saved")
    }

    private func setupStubbedExchangeRate(_ exchangeRate: ExchangeRateResponse, timestamp: Date?) {
        networkService.stubbedExchangeRate = exchangeRate
        storageService.savedExchangeRate = exchangeRate
        storageService.savedTimestamp = timestamp
    }
}

