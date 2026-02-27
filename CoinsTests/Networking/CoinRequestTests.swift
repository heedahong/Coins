//
//  CoinRequestTests.swift
//  CoinsTests
//
//  Created by 홍다희 on 2021/11/18.
//

import Testing
import Foundation
@testable import Coins

struct CoinRequestTests {

    @Test func testMakingURLRequest() throws {
        // given
        let request = CoinRequest.coins(limit: 10, to: nil)

        // when
        let urlRequest = request.makeRequest()

        // then
        #expect(urlRequest?.url?.scheme == "https")
        #expect(urlRequest?.url?.host == "min-api.cryptocompare.com")
        #expect(urlRequest?.url?.path == "/data/top/totalvolfull")
        #expect(urlRequest?.url?.query?.contains("limit=10") == true)
        #expect(urlRequest?.url?.query?.contains("tsym=USD") == true)
    }

    @Test func testParsingResponse() throws {
        // given
        let request = CoinRequest.coins(limit: 1, to: nil)
        let jsonData = MockJSON.coin

        // when
        let response = request.parseResponse(data: jsonData)

        // then
        #expect(response?.coins.count == 1)
        #expect(response?.coins[0].name == "BTC")
        #expect(response?.coins[0].price == 59593.72)
        #expect(response?.coins[0].changePercent24Hour == -1.9684377484975333)
    }

}
