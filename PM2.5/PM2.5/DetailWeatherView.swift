//
//  DetailWeatherView.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/15.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class DetailWeatherView: UIView {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var tempoture: UILabel!
    @IBOutlet weak var currentTemputure: UILabel!
    
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var aqi: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherState: UILabel!
    @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var dressingIndex: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        mainScrollView.contentSize = CGSize(width: 0, height: 100)

    }
    
    

}
