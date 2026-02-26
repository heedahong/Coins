//
//  APILoaderTests.swift
//  CoinsTests
//
//  Created by 홍다희 on 2021/11/21.
//

import Testing
import Foundation
@testable import Coins

struct APIRequestLoaderTests {

    let loader: APIRequestLoader

    init() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        loader = APIRequestLoader(urlSession: urlSession)
    }

    @Test func loaderSuccess() async throws {
        // given
        let request = CoinRequest.coins(limit: 1, to: nil)
        let mockJSONData = MockJSON.coin
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJSONData)
        }

        // when
        let response = try await loader.request(with: request)
        
        // then
        #expect(response.coins.count == 1)
        #expect(response.coins[0].name == "BTC")
        #expect(response.coins[0].price == 59593.72)
        #expect(response.coins[0].changePercent24Hour == -1.9684377484975333)
    }

}
