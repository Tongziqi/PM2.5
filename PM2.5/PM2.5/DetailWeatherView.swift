//
//  DetailWeatherView.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/15.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class DetailWeatherView: UIView {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        mainScrollView.contentSize = CGSize(width: 0, height: 100)

    }
    
    

}
