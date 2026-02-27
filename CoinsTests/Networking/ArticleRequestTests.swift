//
//  ArticleRequestTests.swift
//  CoinsTests
//
//  Created by 홍다희 on 2021/11/21.
//

import Testing
import Foundation
@testable import Coins

struct ArticleRequestTests {

    @Test func testMakingURLRequest() throws {
        // given
        let request = ArticleRequest.articles(category: "BTC")

        // when
        let urlRequest = request.makeRequest()

        // then
        #expect(urlRequest?.url?.scheme == "https")
        #expect(urlRequest?.url?.host == "min-api.cryptocompare.com")
        #expect(urlRequest?.url?.path == "/data/v2/news")
        #expect(urlRequest?.url?.query == "categories=BTC")
    }

    @Test func testParsingResponse() throws {
        // given
        let request = ArticleRequest.articles(category: "BTC")
        let jsonData = MockJSON.article

        // when
        let response = request.parseResponse(data: jsonData)

        // then
        #expect(response?.articles.count == 1)
        #expect(response?.articles[0].title == "Market Watch: BTC Eyes $60K, AVAX to Replace DOGE As Top 10?")
        #expect(response?.articles[0].url == "https://cryptopotato.com/market-watch-btc-eyes-60k-avax-to-replace-doge-as-top-10/")
        #expect(response?.articles[0].imageURL == "https://images.cryptocompare.com/news/default/cryptopotato.png")
    }

}
