//
//  CoinDetailViewController.swift
//  Coins
//
//  Created by 홍다희 on 2021/11/17.
//

import UIKit
import SafariServices
@preconcurrency import DGCharts

final class CoinDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: CoinDetailViewModel!
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var durationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupView()
    }
    
    // MARK: Setup
    
    private func setupViewModel() {
        viewModel.didReceiveHistoricalCoin = { [weak self] chartDatas, duration in
            guard let self = self else { return }
            let entries = chartDatas.map { ChartDataEntry(x: $0.0, y: $0.1)}
            let latest = chartDatas.last?.time
            let dataSet = LineChartDataSet(entries: entries)
            dataSet.mode = .horizontalBezier
            dataSet.colors = [UIColor.systemBlue]
            dataSet.drawCirclesEnabled = false
            dataSet.drawCircleHoleEnabled = false
            dataSet.drawValuesEnabled = false
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            
            let startColor = UIColor.systemBlue
            let endColor = UIColor(white: 1, alpha: 0.3)
            let gradientColor = [startColor.cgColor, endColor.cgColor] as CFArray
            let colorLocations: [CGFloat] = [1.0, 0.0]
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColor, locations: colorLocations)
            dataSet.fill = RadialGradientFill(gradient: gradient!)
            dataSet.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: dataSet)
            self.chartView.data = data
            self.chartView.highlightValue(x: latest!, dataSetIndex: 0)
            self.chartView.xAxis.valueFormatter = DateAxisValueFormatter(duration: duration)
        }
        viewModel.didSelectChartValue = { [weak self] price in
            guard let self = self else { return }
            self.priceLabel.text = price
        }
        viewModel.didReceiveArticles = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }


    private func setupView() {
        coinLabel.text = viewModel.title
        setupChartView()
        setupDurationSegmentedControl()
        setupTableView()
    }

    private func setupChartView() {
        let xAxis = chartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom

        let leftYAxis = chartView.leftAxis
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawLabelsEnabled = false

        let rightYAxis = chartView.rightAxis
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawLabelsEnabled = false

        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = false
        chartView.delegate = self
    }

    private func setupDurationSegmentedControl() {
        durationSegmentedControl.layer.backgroundColor = UIColor.clear.cgColor
        durationSegmentedControl.selectedSegmentTintColor = .systemBlue
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        durationSegmentedControl.setTitleTextAttributes(normalTitleTextAttributes, for:.normal)
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        durationSegmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for:.selected)
        durationSegmentedControl.sendActions(for: .valueChanged)
    }

    private func setupTableView() {
        viewModel.fetchArticles()
    }

    // MARK: - Actions

    @IBAction func durationSegmentedControlDidTap(_ sender: UISegmentedControl) {
        viewModel.selectDuration(at: sender.selectedSegmentIndex)
    }

}

// MARK: - ChartViewDelegate

extension CoinDetailViewController: @preconcurrency ChartViewDelegate {

    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        viewModel.selectChartValue(entry.y)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CoinDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as? ArticleCell else {
            fatalError()
        }

        let viewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = viewModel.url(at: indexPath.row)
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }

}
