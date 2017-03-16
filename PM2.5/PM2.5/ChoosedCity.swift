//
//  ChoosedCity.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/16.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class ChoosedCity: NSObject {
    
    var city: String = ""
    var weather: String = ""
    var temperature: String = ""
    var wind: String = ""
    
    init(city: String, weather: String, temperature: String, wind: String) {
        self.city = city
        self.weather = weather
        self.temperature = temperature
        self.wind = wind
    }

}
