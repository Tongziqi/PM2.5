//
//  Common.swift
//  PM2.5
//
//  Created by 童小托 on 2017/1/22.
//  Copyright © 2017年 童小托. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommonTool {
    
    /// 获得传入Json数据中的平均值
    ///
    /// - Parameter json: 传入的json
    /// - Parameter string: 传入需要的数据
    /// - Returns: 所需要数据的平均值
    class func getAverageNum(json: JSON, string: String) -> Int {
        var sum = 0
        for index in 0..<json.count {
            if let num = json[index][string].int {
                sum += num
            }
        }
        return sum/json.count;
    }
    
    class func pm25ChangeIntoFrame(pm25: Int) -> Int {
        return 199 * pm25 / 500
    }
    
}
