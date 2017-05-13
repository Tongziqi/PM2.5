//
//  ForcastDataLoader.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/6.
//  Copyright © 2017年 童小托. All rights reserved.
//

import Foundation
import IGListKit
import SwiftyJSON

class ForecastDataLoader {
    
    var datas = [ForecastEntry]()
    
    func loadLatest(json: JSON,aqiJson: JSON) {
        let datas = [
            ForecastEntry(imageString: json[1]["dayTime"].stringValue,
                          dataLabel: json[1]["date"].stringValue,
                          temperature: json[1]["temperature"].stringValue,
                          weatherLabel: json[1]["dayTime"].stringValue,
                          weekLabel: json[1]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][0]["aqi"].stringValue),
            ForecastEntry(imageString: json[2]["dayTime"].stringValue,
                          dataLabel: json[2]["date"].stringValue,
                          temperature: json[2]["temperature"].stringValue,
                          weatherLabel: json[2]["dayTime"].stringValue,
                          weekLabel: json[2]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][1]["aqi"].stringValue),
            ForecastEntry(imageString: json[3]["dayTime"].stringValue,
                          dataLabel: json[3]["date"].stringValue,
                          temperature: json[3]["temperature"].stringValue,
                          weatherLabel: json[3]["dayTime"].stringValue,
                          weekLabel: json[3]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][2]["aqi"].stringValue),
            ForecastEntry(imageString: json[4]["dayTime"].stringValue,
                          dataLabel: json[4]["date"].stringValue,
                          temperature: json[4]["temperature"].stringValue,
                          weatherLabel: json[4]["dayTime"].stringValue,
                          weekLabel: json[4]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][3]["aqi"].stringValue),
            ForecastEntry(imageString: json[5]["dayTime"].stringValue,
                          dataLabel: json[5]["date"].stringValue,
                          temperature: json[5]["temperature"].stringValue,
                          weatherLabel: json[5]["dayTime"].stringValue,
                          weekLabel: json[5]["week"].stringValue,
                          aqiLabel:aqiJson["result"][0]["fetureData"][4]["aqi"].stringValue),
            ForecastEntry(imageString: json[6]["dayTime"].stringValue,
                          dataLabel: json[6]["date"].stringValue,
                          temperature: json[6]["temperature"].stringValue,
                          weatherLabel: json[6]["dayTime"].stringValue,
                          weekLabel: json[6]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][5]["aqi"].stringValue),
            ForecastEntry(imageString: json[7]["dayTime"].stringValue,
                          dataLabel: json[7]["date"].stringValue,
                          temperature: json[7]["temperature"].stringValue,
                          weatherLabel: json[7]["dayTime"].stringValue,
                          weekLabel: json[7]["week"].stringValue,
                          aqiLabel: aqiJson["result"][0]["fetureData"][5]["aqi"].stringValue)]
        self.datas = datas
    }
    
    func loadDefault() {
        let datas = [
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-22",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期一", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-23",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期二", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-24",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期三", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-25",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期四", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-26",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期五", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-27",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期六", aqiLabel: "空气质量：80"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-28",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴", weekLabel: "星期日", aqiLabel: "空气质量：80"),
            ]
        self.datas = datas
    }
}
