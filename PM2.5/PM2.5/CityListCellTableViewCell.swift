//
//  CityListCellTableViewCell.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/20.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class CityListCellTableViewCell: UITableViewCell {
    @IBOutlet weak var labelOfCity: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var locatedLabel: UILabel!
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addCityName(_ city: City){
        labelOfCity.text = city.cityCN
    }
    
}
