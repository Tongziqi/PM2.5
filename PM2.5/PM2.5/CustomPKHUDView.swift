//
//  CustomPKHUDView.swift
//  ip
//
//  Created by 童小托 on 2017/3/21.
//  Copyright © 2017年 yunlaiwu. All rights reserved.
//

import UIKit
import PKHUD

class CustomPKHUDView: PKHUDWideBaseView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 10.0
        titleLabel.frame = bounds.insetBy(dx: padding, dy: padding)
    }
    
    
    public init(text: String?, backgroundColor: UIColor, titleColor: UIColor) {
        super.init()
        commonInit(text,backgroundColor: backgroundColor,titleColor: titleColor)
    }
    
    public init(text: String?) {
        super.init()
        commonInit(text)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit("")
    }
    
    func commonInit(_ text: String?) {
        self.backgroundColor = UIColor.black
        titleLabel.text = text
        titleLabel.textColor = UIColor.white
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
    }
    
    
    func commonInit(_ text: String?, backgroundColor: UIColor, titleColor: UIColor) {
         self.backgroundColor = backgroundColor
        titleLabel.text = text
        titleLabel.textColor = titleColor
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
    }
    
    open let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    
    
}
