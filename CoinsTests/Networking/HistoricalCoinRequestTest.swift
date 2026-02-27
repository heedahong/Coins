//
//  HistoricalCoinRequestTest.swift
//  CoinsTests
//
//  Created by 홍다희 on 2021/11/21.
//

import Testing
import Foundation
@testable import Coins

struct HistoricalCoinRequestTest {

    // MARK: - testMakingURLRequest

    @Test func testMakingURLRequest_hour() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .hour)
        // when
        let urlRequest = request.makeRequest()

        // then
        #expect(urlRequest?.url?.scheme == "https")
        #expect(urlRequest?.url?.host == "min-api.cryptocompare.com")
        #expect(urlRequest?.url?.path == "/data/v2/histominute")
        #expect(urlRequest?.url?.query?.contains("fsym=BTC") == true)
        #expect(urlRequest?.url?.query?.contains("tsym=USD") == true)
        #expect(urlRequest?.url?.query?.contains("limit=60") == true)
    }

    @Test func testMakingURLRequest_day() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .day)
        // when
        let urlRequest = request.makeRequest()

        // then
        #expect(urlRequest?.url?.scheme == "https")
        #expect(urlRequest?.url?.host == "min-api.cryptocompare.com")
        #expect(urlRequest?.url?.path == "/data/v2/histohour")
        #expect(urlRequest?.url?.query?.contains("fsym=BTC") == true)
        #expect(urlRequest?.url?.query?.contains("tsym=USD") == true)
        #expect(urlRequest?.url?.query?.contains("limit=24") == true)
    }

    @Test func testMakingURLRequest_week() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .week)
        // when
        let urlRequest = request.makeRequest()

        // then
        #expect(urlRequest?.url?.scheme == "https")
        #expect(urlRequest?.url?.host == "min-api.cryptocompare.com")
        #expect(urlRequest?.url?.path == "/data/v2/histoday")
        #expect(urlRequest?.url?.query?.contains("fsym=BTC") == true)
        #expect(urlRequest?.url?.query?.contains("tsym=USD") == true)
        #expect(urlRequest?.url?.query?.contains("limit=7") == true)
    }

    // MARK: - testParsingResponse

    @Test func testParsingResponse_hour() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .hour)
        let jsonData = MockJSON.HistoricalCoin.hour

        // when
        let response = request.parseResponse(data: jsonData)

        // then
        #expect(response?.historicalCoins.count == 60 + 1)
        #expect(response?.historicalCoins[0].time == 1637494680)
        #expect(response?.historicalCoins[0].price == 58852.76)
    }

    @Test func testParsingResponse_day() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .day)
        let jsonData = MockJSON.HistoricalCoin.day

        // when
        let response = request.parseResponse(data: jsonData)

        // then
        #expect(response?.historicalCoins.count == 24 + 1)
        #expect(response?.historicalCoins[0].time == 1637409600)
        #expect(response?.historicalCoins[0].price == 58633.2)
    }

    @Test func testParsingResponse_week() throws {
        // given
        let request = HistoricalCoinRequest.historicalCoin(from: "BTC", to: nil, duration: .week)
        let jsonData = MockJSON.HistoricalCoin.week

        // when
        let response = request.parseResponse(data: jsonData)

        // then
        #expect(response?.historicalCoins.count == 7 + 1)
        #expect(response?.historicalCoins[0].time == 1636848000)
        #expect(response?.historicalCoins[0].price == 65509.06)
    }

}
