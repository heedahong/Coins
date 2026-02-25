//
//  DateAxisValueFormatter.swift
//  Coins
//
//  Created by 홍다희 on 2021/11/20.
//

import Foundation
import DGCharts

final class DateAxisValueFormatter: NSObject, AxisValueFormatter {

    let duration: Duration

    init(duration: Int) {
        self.duration = Duration(rawValue: duration) ?? .day
        super.init()
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = duration.dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: value))
    }

}
