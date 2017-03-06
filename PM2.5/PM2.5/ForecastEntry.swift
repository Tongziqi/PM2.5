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
    
    var image: UIImage? = UIImage(named: "晴天")
    var dataLabel: String? = ""
    var highLable: String? = ""
    var lowLabel: String? = ""
    
    init(image: UIImage, dataLabel: String, highLable: String, lowLabel: String) {
        self.image = image
        self.dataLabel = dataLabel
        self.highLable = highLable
        self.lowLabel = lowLabel
    }
    init(dataLabel: String, highLable: String, lowLabel: String) {
        self.dataLabel = dataLabel
        self.highLable = highLable
        self.lowLabel = lowLabel
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self as! NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(toDiffableObject: object)
    }
}
