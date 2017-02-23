//
//  VersionControl.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/23.
//  Copyright © 2017年 童小托. All rights reserved.
//

import Foundation

class VersionControl {
    static var isRealFistUseCache: Bool? = nil
    /// 单次启动内，可重复调用返回一致
    class func checkIsRealFirstUse() -> Bool {
        if isRealFistUseCache != nil {
            return isRealFistUseCache!
        }
        
        let key = "real_already_use"
        
        let hasUse = UserDefaults.standard.object(forKey: key) as? String
        
        if hasUse != nil {
            isRealFistUseCache = false
            return false
        } else {
            UserDefaults.standard.set("1", forKey: key)
            UserDefaults.standard.synchronize()
            isRealFistUseCache = true
            return true
        }
    }
}
