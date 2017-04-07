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

class TableViewController: UIViewController, IAxisValueFormatter, UIScrollViewDelegate, ChartViewDelegate {
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
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        barChartView = LineChartView.init(frame: CGRect(x: 0, y: ScreenBounds.height/4, width: ScreenWidth * 2, height: 200))
        axisFormatDelegate = self
        setData(json: json["result"][0]["hourData"])
        
        setDefault()
        
        updateChartWithData()
        
        
        let label = UILabel(frame: CGRect(x: ScreenWidth / 3 - 5 , y: ScreenBounds.height/4 - 15, width: ScreenWidth * 2, height: 10))
        label.textColor = UIColor.flatWhite
        label.text = "24小时的AQI指数变化"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.scrollView.addSubview(barChartView!)
        self.scrollView.addSubview(label)
        
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
            let chartDataSet = LineChartDataSet(values: dataEntries, label: "AQI指数")
            
            chartDataSet.circleColors = [UIColor.flatGreen]
            chartDataSet.valueTextColor = UIColor.flatWhite
            chartDataSet.colors = [UIColor.flatGreen]
            
            chartDataSet.cubicIntensity = 0.2 // 曲线弧度
            chartDataSet.circleRadius = 5.0 //拐点半径
            chartDataSet.drawCircleHoleEnabled = false //是否绘制中间的空心
            chartDataSet.circleHoleRadius = 3.0 //空心的半径
            chartDataSet.circleHoleColor = UIColor.flatWhite //空心的颜色
            chartDataSet.highlightEnabled = false // //选中拐点,是否开启高亮效果(显示十字线)
            chartDataSet.mode = LineChartDataSet.Mode.linear
            
            
            barChartView?.xAxis.labelPosition = .bottom
            let chartData = LineChartData(dataSet: chartDataSet)
            
            // 加各种污染界限
            let midjx = ChartLimitLine(limit: 150, label: "中度污染")
            midjx.lineColor = UIColor.flatOrange
            midjx.valueTextColor = UIColor.flatOrange
            midjx.valueFont = NSUIFont.systemFont(ofSize: 11.0)
            midjx.lineWidth = 0.5
            midjx.lineDashLengths = [5.0,5.0]
            midjx.labelPosition = ChartLimitLine.LabelPosition.rightBottom
            barChartView?.leftAxis.addLimitLine(midjx)
            let highjx = ChartLimitLine(limit: 200, label: "重度污染")
            highjx.lineColor = UIColor.flatRed
            highjx.valueTextColor = UIColor.flatRed
            highjx.valueFont = NSUIFont.systemFont(ofSize: 11.0)
            highjx.lineWidth = 0.5
            highjx.lineDashLengths = [5.0,5.0]
            highjx.labelPosition = ChartLimitLine.LabelPosition.rightBottom
            barChartView?.leftAxis.addLimitLine(highjx)
            let hugejx = ChartLimitLine(limit: 300, label: "严度污染")
            hugejx.lineColor = UIColor.flatRedDark
            hugejx.valueTextColor = UIColor.flatRedDark
            hugejx.valueFont = NSUIFont.systemFont(ofSize: 11.0)
            hugejx.lineWidth = 0.5
            hugejx.lineDashLengths = [5.0,5.0]
            hugejx.labelPosition = ChartLimitLine.LabelPosition.rightBottom
            barChartView?.leftAxis.addLimitLine(hugejx)
            
            barChartView?.data = chartData
            let xaxis = barChartView?.xAxis
            xaxis?.valueFormatter = axisFormatDelegate
            barChartView?.animate(xAxisDuration: 1.0, easingOption: .linear)
        } else {
            barChartView?.noDataText = "没有获得数据，啦啦啦"
        }
        
    }
    
    func setDefault() {
        
        barChartView?.layer.cornerRadius = 20
        barChartView?.layer.masksToBounds = true
        barChartView?.backgroundColor = UIColor.flatBlack //设置背景颜色
        barChartView?.chartDescription?.text = "" //隐藏描述文字
        barChartView?.noDataText = "没有获得数据，啦啦啦" // 设置没有数据的显示内容
        barChartView?.legend.enabled = true //显示图例说明
        barChartView?.legend.textColor = UIColor.flatWhite
        barChartView?.scaleYEnabled = false //取消Y轴缩放
        barChartView?.scaleXEnabled = false //取消X轴缩放
        barChartView?.doubleTapToZoomEnabled = false //取消双击缩放
        barChartView?.dragDecelerationEnabled = false //拖拽后是否有惯性效果
        barChartView?.dragDecelerationFrictionCoef = 0 //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        barChartView?.rightAxis.enabled = false //不绘制右边轴的信息
        barChartView?.leftAxis.enabled = true //绘制左边轴的信息
        barChartView?.xAxis.enabled = true
        barChartView?.xAxis.drawGridLinesEnabled = false //不绘制网络线
        barChartView?.xAxis.axisLineColor = UIColor.flatWhite // x 轴的网络线颜色
        barChartView?.xAxis.labelPosition = XAxis.LabelPosition.bottom // X轴的位置
        barChartView?.xAxis.granularity = 1 // 间隔为1
        barChartView?.xAxis.gridLineWidth = 0 // 线宽度为0
        barChartView?.xAxis.labelTextColor = UIColor.flatWhite
        barChartView?.leftAxis.gridLineWidth = 0
        barChartView?.rightAxis.gridLineWidth =  0
        barChartView?.leftAxis.labelTextColor = UIColor.flatWhite
    }
    
    
    func setData(json: JSON) {
        if json.isEmpty {
            return
        }
        for data in json.array! {
            self.timeData.append(data["dateTime"].stringValue.components(separatedBy: " ").last!)
            self.aqiData.append(data["aqi"].doubleValue)
        }
        self.timeData.reverse()
        self.aqiData.reverse()
    }
    
    func bgOnTap(_gusture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
