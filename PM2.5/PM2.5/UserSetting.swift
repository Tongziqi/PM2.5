//
//  UserSetting.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/24.
//  Copyright © 2017年 童小托. All rights reserved.
//

import Foundation
import UIKit

class UserSetting: NSObject {
    static let Appkey: String! = "23252"
    static let Secret: String! = "3d44f2da53534e59a2d9d0a8cb2867f4"
    static let Sign: String! = "0cb4e1d9a759db575d36cb5db8f2ac69"
    static let WeatherTodayUrl: String! = "https://sapi.k780.com/"
    
    static let newWeatherUrl: String! = "http://apicloud.mob.com/v1/weather/query"
    static let newAqiUrl: String! = "https://apicloud.mob.com/environment/query"
    static let newAppkey: String! = "1c2506cc3a934"
    
    
    
    static let WeatherCondition: [String] = ["晴","多云","阴","阵雨","雷阵雨","暴雪","暴到大暴雨","暴雨","大到特大暴雨","大暴雨","大到暴雪","大雪","大到暴雨","大雨","冻雨","多云转晴","多云转阴","浮城","雷阵雨","雷阵雨伴有冰雹","霾","强沙尘暴","沙尘暴","特大暴雨","雾","小到中雪","小雪","小到中雨","小雨","扬沙","雨夹雪","阵雪","阵雨","中到大雪","中雪","中到大雨","中雨"]
    
    static let chooseWeatherCondition: [String] = ["多云,少云,晴,阴,小雨,雨,雷阵雨,中雨,阵雨,零散阵雨,零散雷雨,小雪,雨夹雪,阵雪,霾,暴雨,大雨,大雪,中雪"]
    
}

typealias Task = (_ cancel : Bool) -> Void

@discardableResult func delay(_ time:Foundation.TimeInterval, task:@escaping ()->()) ->  Task? {
    
    func dispatch_later(_ block:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block)
    }
    
    var closure: (()->())? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result;
}

func cancel(_ task: Task?) {
    task?(true)
}


