//
//  TableViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/4/6.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class TableViewController: UIViewController, IAxisValueFormatter, UIScrollViewDelegate {
//    @IBOutlet weak var scorllView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var json: JSON = []
    var timeData: [String] = []
    var aqiData: [Double] = []
    var barChartView: LineChartView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: ScreenWidth * 2 + 10, height: ScreenHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)

        barChartView = LineChartView.init(frame: CGRect(x: 0, y: ScreenBounds.height/4, width: ScreenWidth * 2, height: 200))
        
        axisFormatDelegate = self
        setData(json: json["result"][0]["hourData"])
        barChartView?.layer.cornerRadius = 20
        barChartView?.layer.masksToBounds = true
        barChartView?.backgroundColor = UIColor.flatBlack
        updateChartWithData()
        self.scrollView.addSubview(barChartView!)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(bgOnTap)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return timeData[Int(value)]
    }
    
    //保存图表的功能还没有做
    
    func updateChartWithData() {
        if aqiData.count > 0 {
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<self.aqiData.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: self.aqiData[i])
                dataEntries.append(dataEntry)
            }
            let chartDataSet = LineChartDataSet(values: dataEntries, label: "aqi")
            chartDataSet.colors = ChartColorTemplates.colorful()
            let chartData = LineChartData(dataSet: chartDataSet)
            // 加上一个界限, 演示图中红色的线
            let jx = ChartLimitLine(limit: 12.0, label: "危险了")
            barChartView?.rightAxis.addLimitLine(jx)
            barChartView?.data = chartData
            
            let xaxis = barChartView?.xAxis
            xaxis?.valueFormatter = axisFormatDelegate
            barChartView?.animate(xAxisDuration: 1.0, easingOption: .linear)
        } else {
            barChartView?.noDataText = "没有获得数据，啦啦啦"
        }
        
    }
    
    func setData(json: JSON) {
        for data in json.array! {
            self.timeData.append(data["dateTime"].stringValue)
            self.aqiData.append(data["aqi"].doubleValue)
        }
        self.timeData.reverse()
        self.aqiData.reverse()
    }
    
    func bgOnTap(_gusture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
