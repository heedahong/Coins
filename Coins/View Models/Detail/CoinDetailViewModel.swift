//
//  CoinDetailViewModel.swift
//  Coins
//
//  Created by 홍다희 on 2021/11/17.
//

import Foundation

@MainActor
final class CoinDetailViewModel {
    
    var didReceiveHistoricalCoin: (@MainActor ([(time: TimeInterval, price: Double)], Int) -> Void)?
    var didReceiveArticles: (@MainActor () -> Void)?
    var didSelectChartValue: (@MainActor (String?) -> Void)?

    private let coin: Coin
    private let service: CoinServiceAPI
    private var articles: [Article] = [] {
        didSet {
            didReceiveArticles?()
        }
    }
    
    init(coin: Coin,
         service: CoinServiceAPI = CoinServiceAPI()) {
        self.coin = coin
        self.service = service
    }
    
}

extension CoinDetailViewModel {
    
    var title: String {
        coin.name
    }

    
    func selectDuration(at index: Int)  {
        let duration: Duration = Duration(rawValue: index) ?? .day
        self.fetchHistoricalCoins(duration: duration)
    }
    
    func selectChartValue(_ value: Double) {
        didSelectChartValue?(CurrencyFormatter.string(from: value))
    }
    
    func fetchHistoricalCoins(duration: Duration) {
        Task {
            do {
                let value = try await service.historicalCoins(from: coin, duration: duration)
                let durationValue = duration.rawValue
                let chartData = value.map { ($0.time, $0.price) }
                self.didReceiveHistoricalCoin?(chartData, durationValue)
            } catch {
                // handle error
            }
        }
    }

    func fetchArticles() {
        Task {
            do {
                let articles = try await service.articlesFor(coin)
                self.articles = articles
            } catch {
                // handle error
            }
        }
    }
    
}

extension CoinDetailViewModel {

    var numberOfRows: Int {
        return articles.count
    }

    func viewModelForCell(at index: Int) -> ArticleViewModel {
        return ArticleViewModel(article: articles[index])
    }

    func url(at index: Int) -> URL {
        let url = URL(string: articles[index].url)!
        return url
    }

}
