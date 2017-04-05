//
//  ChooseCellTableViewCell.swift
//  PM2.5
//
//  Created by 童小托 on 2017/4/5.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class ChooseCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locatedLabel: UILabel!
    @IBOutlet weak var labelOfCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addCityName(_ city: City){
        labelOfCity.text = city.cityCN
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initdata() {
        locatedLabel.textColor = UIColor.flatGray
        locatedLabel.text = ""
        labelOfCity.text = ""
        selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func colorWithHex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat(Float((hex >> 16) & 0xFF) / 255.0)
        let green = CGFloat(Float((hex >> 8) & 0xFF) / 255.0)
        let blue = CGFloat(Float((hex >> 0) & 0xFF) / 255.0)
        let alpha = CGFloat(alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // 解决 ios8 tableview 自适应大小的时候，第一次展现的时候不生效的问题。
    override func layoutSubviews() {
        super.layoutSubviews()
        //        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
}
