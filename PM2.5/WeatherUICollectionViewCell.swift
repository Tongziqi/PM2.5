//
//  WeatherUICollectionViewCell.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/2.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import IGListKit
import ChameleonFramework

class WeatherUICollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var temptureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initdata() {
        self.image?.image = UIImage(named: "多云")
        self.dataLabel?.textColor = UIColor.flatGray
        self.weather?.text = "大雪"
        self.dataLabel?.text = "2017-02-01"
        self.temptureLabel?.text = "56°/ 87°"
    }
}
