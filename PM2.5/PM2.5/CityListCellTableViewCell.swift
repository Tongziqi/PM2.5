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
    @IBOutlet weak var cityLocationimage: UIImageView!
    @IBOutlet weak var locatedLabel: UILabel!
    
    
    var bgView: UIView!
    
    
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
        cityLocationimage.image = UIImage(named: "umbrella")
        locationImg.image = UIImage(named: "location")
        locationImg.isHidden = true
        locatedLabel.textColor = UIColor.gray
        locatedLabel.text = ""
        labelOfCity.text = ""
        selectionStyle = UITableViewCellSelectionStyle.none
        contentView.layer.cornerRadius = 20
        
    }
    
    // 解决 ios8 tableview 自适应大小的时候，第一次展现的时候不生效的问题。
    override func layoutSubviews() {
        super.layoutSubviews()
        //        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    
    
}
