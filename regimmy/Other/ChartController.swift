//
//  ChartController.swift
//  regimmy
//
//  Created by Natalia Sonina on 20.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import Charts

class ChartController {
    
    var chartView: LineChartView!
    var delegate: ChartViewDelegate?
    
    var datas: [[ChartDataEntry]] = []
    
    let data1: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 20),   //food
        ChartDataEntry(x: 1, y: 22),
        ChartDataEntry(x: 3, y: 20),
        ChartDataEntry(x: 6, y: 25),
        ChartDataEntry(x: 7, y: 23),
        
        ChartDataEntry(x: 8, y: 45),
        ChartDataEntry(x: 9, y: 34),
        ChartDataEntry(x: 10, y: 30),
        ChartDataEntry(x: 11, y: 21),
        ChartDataEntry(x: 12, y: 29),
        
        ChartDataEntry(x: 13, y: 17),
        ChartDataEntry(x: 15, y: 18),
        ChartDataEntry(x: 17, y: 20),
        ChartDataEntry(x: 19, y: 28),
        ChartDataEntry(x: 21, y: 30),
        
        ChartDataEntry(x: 25, y: 40),
        ChartDataEntry(x: 26, y: 45),
        ChartDataEntry(x: 27, y: 50),
        ChartDataEntry(x: 28, y: 26),
        ChartDataEntry(x: 29, y: 35)]
    
    let data2: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 78.5), // massa
        ChartDataEntry(x: 8, y: 79.6),
        ChartDataEntry(x: 16, y: 78.8),
        ChartDataEntry(x: 24, y: 79.0),
        ChartDataEntry(x: 29, y: 79.8)]
    
    let data3: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 120), //train
        ChartDataEntry(x: 2, y: 110),
        ChartDataEntry(x: 5, y: 115),
        ChartDataEntry(x: 8, y: 116),
        ChartDataEntry(x: 10, y: 120),
        
        ChartDataEntry(x: 11, y: 130),
        ChartDataEntry(x: 14, y: 124),
        ChartDataEntry(x: 16, y: 140),
        ChartDataEntry(x: 20, y: 120),
        ChartDataEntry(x: 24, y: 110)]
    
    let mainColors: [UIColor] = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)]
    
    let labes: [String] = ["еда", "масса", "тренировка"]
    
    let dates: [String] = ["1 сент", "2 сентя", "3 сентяб", "4 сентябр", "5 сентября", "6 сен", "7 сен", "8 сен", "9 сен", "10 сен", "11 сен", "12 сен", "13 сен", "14 сен", "15 сен", "16 сен", "17 сен", "18 сен", "19 сен", "20 сен", "21 сен", "22 сен", "23 сен", "24 сен", "25 сен", "26 сен", "27 сен", "28 сен", "29 сен", "30 сен"]
    
    init(whith chartView:LineChartView, delegate: ChartViewDelegate) {
        self.chartView = chartView
        self.delegate = delegate
        
        datas.append(data1)
        datas.append(data2)
        datas.append(data3)
        
        configureChart()
        putData()
    }
    
    func configureChart(){
        chartView.delegate = delegate
        //chartView.chartDescription?.text = "Статистика"
        
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
        
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 150, label: "max")
        ll1.lineWidth = 2
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let ll2 = ChartLimitLine(limit: 5, label: "min")
        ll2.lineWidth = 2
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 175
        leftAxis.axisMinimum = -10
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 8)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.labelRotationAngle = 45
        xAxis.wordWrapWidthPercent = 10
        xAxis.valueFormatter = MyDateFormatter(dates: dates)
        
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
    }
    
    func putData(){
        
        var sets: [LineChartDataSet] = (0..<3).map{(i) -> LineChartDataSet in
            let set = LineChartDataSet(values: datas[i], label: "")
            set.drawIconsEnabled = false
            set.label = nil
            set.mode = .cubicBezier
            
            set.highlightLineDashLengths = [5, 2.5]
            set.setColor(mainColors[i])
            set.setCircleColor(.black)
            set.lineWidth = 2
            set.circleRadius = 3
            set.drawCircleHoleEnabled = false
            set.valueFont = .systemFont(ofSize: 9)
            set.formLineDashLengths = [5, 2.5]
            set.formLineWidth = 1
            set.formSize = 15
            
            
            let gradientColors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
                                  mainColors[i].withAlphaComponent(0.8).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 0.75
            set.fill = Fill(linearGradient: gradient, angle: 90)
            set.drawFilledEnabled = false
            
            return set
        }
        
        var chartData = LineChartData(dataSets: sets)
        chartView.data = chartData
        
    }
}

public class MyDateFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    private var dates: [String]!
    
    init(dates: [String]) {
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        self.dates = dates
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //let strdate = dateFormatter.string(from: Date(timeIntervalSince1970: value))
        if Int(value) < dates.count {
            return dates[Int(value)]
        }else{
            return "more"
        }
    }
}

