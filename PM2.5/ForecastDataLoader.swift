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
            ForecastEntry(image: UIImage(named: json["result"][0]["weather"].stringValue)!,
                          dataLabel: json["result"][0]["days"].stringValue,
                          highLable: json["result"][0]["temp_high"].stringValue,
                          lowLabel: json["result"][0]["temp_low"].stringValue,
                          weatherLabel: json["result"][0]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][1]["weather"].stringValue)!,
                          dataLabel: json["result"][1]["days"].stringValue,
                          highLable: json["result"][1]["temp_high"].stringValue,
                          lowLabel: json["result"][1]["temp_low"].stringValue,
                          weatherLabel: json["result"][1]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][2]["weather"].stringValue)!,
                          dataLabel: json["result"][2]["days"].stringValue,
                          highLable: json["result"][2]["temp_high"].stringValue,
                          lowLabel: json["result"][2]["temp_low"].stringValue,
                          weatherLabel: json["result"][2]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][3]["weather"].stringValue)!,
                          dataLabel: json["result"][3]["days"].stringValue,
                          highLable: json["result"][3]["temp_high"].stringValue,
                          lowLabel: json["result"][3]["temp_low"].stringValue,
                          weatherLabel: json["result"][3]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][4]["weather"].stringValue)!,
                          dataLabel: json["result"][4]["days"].stringValue,
                          highLable: json["result"][4]["temp_high"].stringValue,
                          lowLabel: json["result"][4]["temp_low"].stringValue,
                        weatherLabel: json["result"][4]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][5]["weather"].stringValue)!,
                          dataLabel: json["result"][5]["days"].stringValue,
                          highLable: json["result"][5]["temp_high"].stringValue,
                          lowLabel: json["result"][5]["temp_low"].stringValue,
                          weatherLabel: json["result"][5]["weather"].stringValue),
            ForecastEntry(image: UIImage(named: json["result"][5]["weather"].stringValue)!,
                          dataLabel: json["result"][6]["days"].stringValue,
                          highLable: json["result"][6]["temp_high"].stringValue,
                          lowLabel: json["result"][6]["temp_low"].stringValue,
                          weatherLabel: json["result"][6]["weather"].stringValue)
        ]
        self.datas = datas
    }
    
    func loadDefault() {
        let datas = [
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "1990-09-22",
                          highLable: "40",
                          lowLabel: "10",
                          weatherLabel: "晴")
                   ]
        self.datas = datas
    }
}
