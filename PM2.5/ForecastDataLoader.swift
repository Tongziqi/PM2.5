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
    
    func loadLatest(json: JSON) {
        let datas = [
            ForecastEntry(imageString: json[1]["dayTime"].stringValue,
                          dataLabel: json[1]["date"].stringValue,
                          temperature: json[1]["temperature"].stringValue,
                          weatherLabel: json[1]["dayTime"].stringValue),
            ForecastEntry(imageString: json[2]["dayTime"].stringValue,
                          dataLabel: json[2]["date"].stringValue,
                          temperature: json[2]["temperature"].stringValue,
                          weatherLabel: json[2]["dayTime"].stringValue),
            ForecastEntry(imageString: json[3]["dayTime"].stringValue,
                          dataLabel: json[3]["date"].stringValue,
                          temperature: json[3]["temperature"].stringValue,
                          weatherLabel: json[3]["dayTime"].stringValue),
            ForecastEntry(imageString: json[4]["dayTime"].stringValue,
                          dataLabel: json[4]["date"].stringValue,
                          temperature: json[4]["temperature"].stringValue,
                          weatherLabel: json[4]["dayTime"].stringValue),
            ForecastEntry(imageString: json[5]["dayTime"].stringValue,
                          dataLabel: json[5]["date"].stringValue,
                          temperature: json[5]["temperature"].stringValue,
                          weatherLabel: json[5]["dayTime"].stringValue),
            ForecastEntry(imageString: json[6]["dayTime"].stringValue,
                          dataLabel: json[6]["date"].stringValue,
                          temperature: json[6]["temperature"].stringValue,
                          weatherLabel: json[6]["dayTime"].stringValue),
            ForecastEntry(imageString: json[7]["dayTime"].stringValue,
                          dataLabel: json[7]["date"].stringValue,
                          temperature: json[7]["temperature"].stringValue,
                          weatherLabel: json[7]["dayTime"].stringValue)]
        self.datas = datas
    }
    
    func loadDefault() {
        let datas = [
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-22",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-23",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-24",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-25",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-26",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-27",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
            ForecastEntry(imageString: "晴",
                          dataLabel: "1990-09-28",
                          temperature: "17°C / 7°C",
                          weatherLabel: "晴"),
                   ]
        self.datas = datas
    }
}
