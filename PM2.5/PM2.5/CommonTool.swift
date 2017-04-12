//
//  Common.swift
//  PM2.5
//
//  Created by 童小托 on 2017/1/22.
//  Copyright © 2017年 童小托. All rights reserved.
//

import Foundation
import SwiftyJSON


public let NavigationH: CGFloat = 64
public let TabBarH: CGFloat = 49
public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
public let ScreenBounds: CGRect = UIScreen.main.bounds


class CommonTool {
    
    
    class func getLocationCityName(cityName: String) -> String {
        var parserXML: ParserXML!
        var parserCities = [City]()

        parserXML = ParserXML()
        parserCities = parserXML.cities
        
        parserCities = parserCities.filter({ (city) -> Bool in
            return city.cityCN.lowercased().contains(cityName.lowercased())
        })
        
        if parserCities.isEmpty {
            return "获取地理位置失败"
        } else {
            return (parserCities.first?.cityCN.components(separatedBy: "/").first)!}
        
    }
    
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
    
    
    class func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    class func dataFilePath() -> String{
        return (documentsDirectory() as NSString).appendingPathComponent("Cities.plist")
    }
    
    class func saveCity(cities: [City]){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(cities, forKey: "Cities")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    class func loadData( cities: inout [City]) -> [City]{
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                cities = unarchiver.decodeObject(forKey: "Cities") as! [City]
                unarchiver.finishDecoding()
            }
        }
        
        return cities
    }
    
}
