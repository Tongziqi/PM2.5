//
//  UserSetting.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/24.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class UserSetting: NSObject {
    static let Appkey: String! = "23252"
    static let Secret: String! = "3d44f2da53534e59a2d9d0a8cb2867f4"
    static let Sign: String! = "0cb4e1d9a759db575d36cb5db8f2ac69"
    static let WeatherTodayUrl: String! = "https://sapi.k780.com/"
    
    static let newWeatherUrl: String! = "http://apicloud.mob.com/v1/weather/query"
    static let newAqiUrl: String! = "https://apicloud.mob.com/environment/query"
    static let newAppkey: String! = "1c2506cc3a934"
    
    
    
    static let WeatherCondition: [String] = ["晴","多云","阴","阵雨","雷阵雨","暴雪","暴雨-大暴雨","暴雨","大暴雨-特大暴雨","大暴雨","大雪-暴雪","大雪","大雨-暴雨","大雨","冻雨","多云转晴","多云转阴","浮城","雷阵雨","雷阵雨伴有冰雹","霾","强沙尘暴","沙尘暴","特大暴雨","雾","小雪-中雪","小雪","小雨-中雨","小雨","扬沙","雨夹雪","阵雪","阵雨","中雪-大雪","中雪","中雨-大雨","中雨"]
}


