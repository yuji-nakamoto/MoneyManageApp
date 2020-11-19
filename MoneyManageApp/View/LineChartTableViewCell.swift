//
//  LineChartTableViewCell.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/11/11.
//

import UIKit
import Charts
import RealmSwift

class LineChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var previousMonthLabel: UILabel!
    @IBOutlet weak var noDataLabel2: UILabel!
    @IBOutlet weak var chartViewRightConst: NSLayoutConstraint!
    @IBOutlet weak var chartViewLeftConst: NSLayoutConstraint!
    @IBOutlet weak var moneyRightConst: NSLayoutConstraint!
    @IBOutlet weak var monthlyLeftConst: NSLayoutConstraint!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var transionLabel: UILabel!
    @IBOutlet weak var transionLeftConst: NSLayoutConstraint!
    
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
        
        dataSet.circleHoleColor = UIColor(named: O_BLUE)
        dataSet.circleColors = [UIColor(named: O_BLUE)!]
        dataSet.drawValuesEnabled = false
        dataSet.colors = [UIColor(named: CARROT_ORANGE)!]
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch (UIScreen.main.nativeBounds.height) {
        case 2048:
            changeLayout1()
            break
        case 2160:
            changeLayout1()
            break
        case 2360:
            changeLayout1()
            break
        case 2388:
            changeLayout1()
            break
        case 2732:
            changeLayout2()
            break
        default:
            break
        }
    }
    
    private func changeLayout1() {
        
        chartViewLeftConst.constant = 30
        chartViewRightConst.constant = 30
        chartViewHeight.constant = 300
        moneyRightConst.constant = 30
        monthlyLeftConst.constant = 30
        transionLeftConst.constant = 30
        
        monthlyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 22)
        previousMonthLabel.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        moneyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 27)
        transionLabel.font = UIFont(name: "HiraMaruProN-W4", size: 17)
        
        viewHeight.constant = 60
    }
    
    private func changeLayout2() {
        
        chartViewLeftConst.constant = 30
        chartViewRightConst.constant = 30
        chartViewHeight.constant = 400
        moneyRightConst.constant = 40
        monthlyLeftConst.constant = 40
        transionLeftConst.constant = 40
        
        monthlyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 27)
        previousMonthLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        moneyLabel.font = UIFont(name: "HiraMaruProN-W4", size: 37)
        transionLabel.font = UIFont(name: "HiraMaruProN-W4", size: 20)
        
        viewHeight.constant = 65
    }
}
