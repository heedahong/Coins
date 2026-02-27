//
//  ArticleService.swift
//  Coins
//
//  Created by 홍다희 on 2021/11/15.
//

import Foundation

final class CoinServiceAPI: Sendable {
    
    private let apiRequestLoader: APIRequestLoader

    init(apiRequestLoader: APIRequestLoader = APIRequestLoader()) {
        self.apiRequestLoader = apiRequestLoader
    }
    
    func coins() async throws -> [Coin] {
        let endpoint = CoinRequest.coins(limit: 20, to: nil)
        let response = try await apiRequestLoader.request(with: endpoint)
        return response.coins
    }

    func historicalCoins(from: Coin, duration: Duration) async throws -> [HistoricalCoin] {
        let endpoint = HistoricalCoinRequest.historicalCoin(from: from.name, to: nil, duration: duration)
        let response = try await apiRequestLoader.request(with: endpoint)
        return response.historicalCoins
    }

    func articlesFor(_ coin: Coin) async throws -> [Article] {
        let endpoint = ArticleRequest.articles(category: coin.name)
        let response = try await apiRequestLoader.request(with: endpoint)
        return response.articles
    }

}
