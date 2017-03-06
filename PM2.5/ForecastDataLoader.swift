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
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][0]["days"].stringValue,
                          highLable: json["result"][0]["temp_high"].stringValue,
                          lowLabel: json["result"][0]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][1]["days"].stringValue,
                          highLable: json["result"][1]["temp_high"].stringValue,
                          lowLabel: json["result"][1]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][2]["days"].stringValue,
                          highLable: json["result"][2]["temp_high"].stringValue,
                          lowLabel: json["result"][2]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][3]["days"].stringValue,
                          highLable: json["result"][3]["temp_high"].stringValue,
                          lowLabel: json["result"][3]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][4]["days"].stringValue,
                          highLable: json["result"][4]["temp_high"].stringValue,
                          lowLabel: json["result"][4]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][5]["days"].stringValue,
                          highLable: json["result"][5]["temp_high"].stringValue,
                          lowLabel: json["result"][5]["temp_low"].stringValue),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: json["result"][6]["days"].stringValue,
                          highLable: json["result"][6]["temp_high"].stringValue,
                          lowLabel: json["result"][6]["temp_low"].stringValue)
        ]
        self.datas = datas
    }
    
    func loadDefault() {
        let datas = [
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10"),
            ForecastEntry(image: UIImage(named:"晴")!,
                          dataLabel: "测试",
                          highLable: "40",
                          lowLabel: "10")
                   ]
        self.datas = datas
    }
}
