//
//  ForecastEntry.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/6.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Foundation
import IGListKit

class ForecastEntry: IGListDiffable {
    
    var imageString: String? = ""
    var image: UIImage? = UIImage(named: "晴天")
    var dataLabel: String? = ""
    var temperature: String? = ""
    var weatherLabel: String? = ""
    
    init(imageString: String, dataLabel: String, temperature: String, weatherLabel: String){
        self.weatherLabel = weatherLabel
        self.imageString = imageString
        self.dataLabel = dataLabel
        self.temperature = temperature
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self as! NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(toDiffableObject: object)
    }
}
