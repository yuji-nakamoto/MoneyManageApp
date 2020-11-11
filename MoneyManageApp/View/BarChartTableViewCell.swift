//
//  BarChartTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/11.
//

import UIKit
import Charts
import RealmSwift

class BarChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var previousMonthLabel: UILabel!
    @IBOutlet weak var noDataLabel2: UILabel!
    
    var moneyArray = [Monthly]()
    
    func configureBarChartCell() {
        
        lineChartView.delegate = self
        moneyLabel.text = ""
        monthlyLabel.text = ""
        previousMonthLabel.text = ""
        lineChartView.leftAxis.gridColor = .clear
        
        var dataEntries: [ChartDataEntry] = []
        
        let realm = try! Realm()
        let monthly = realm.objects(Monthly.self)
        moneyArray.append(contentsOf: monthly)
        
        if moneyArray.count == 0 {
            lineChartView.isHidden = true
            noDataLabel.isHidden = false
            noDataLabel2.isHidden = false
            return
        } else {
            lineChartView.isHidden = false
            noDataLabel.isHidden = true
            noDataLabel2.isHidden = true
        }
        
        for i in 0..<monthly.count {
            dataEntries.append((ChartDataEntry(x: Double(i), y: Double(monthly[i].money))))
            monthlyLabel.text = monthly[i].date
            let result = String.localizedStringWithFormat("%d", monthly[i].money)
            moneyLabel.text = "¥" + String(result)
            previousMonthLabel.text = "(\(monthly[i].previousMonth))"
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.drawZeroLineEnabled = false
        lineChartView.leftAxis.labelFont = UIFont(name: "", size: 0)!
        lineChartView.leftAxis.gridColor = .systemGray
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.legend.enabled = false
        
        dataSet.circleHoleColor = .systemGreen
        dataSet.circleColors = [.systemGreen]
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemBlue]
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let dataSet = lineChartView.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            let date = moneyArray[sliceIndex].date
            let money = moneyArray[sliceIndex].money
            let previousMonth = moneyArray[sliceIndex].previousMonth
            
            previousMonthLabel.text = "(\(previousMonth))"
            monthlyLabel.text = date
            let result = String.localizedStringWithFormat("%d", money)
            moneyLabel.text = "¥" + String(result)
        }
    }
}
