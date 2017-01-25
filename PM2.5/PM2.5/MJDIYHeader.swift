//
//  MJDIYHeader.swift
//  PM2.5
//
//  Created by 童小托 on 2017/1/25.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import MJRefresh


class MJDIYHeader: MJRefreshHeader {
    
    var label:UILabel!
    var logo:UIImageView!
    var loading:UIActivityIndicatorView!
    
    override func prepare()
    {
        super.prepare()
        // 设置高度
        self.mj_h = 50
        
        self.label =  UILabel()
        self.label.textColor = UIColor.gray
        self.label.font = UIFont.boldSystemFont(ofSize: 16)
        self.label.textAlignment = NSTextAlignment.center
        self.addSubview(self.label)
        
        self.logo =  UIImageView(image:UIImage(named: "icon_placeholder"))
        self.logo.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(self.logo)
        
        self.loading =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.addSubview(self.loading)
    }
    
    override func placeSubviews()
    {
        super.placeSubviews()
        
        self.label.frame = self.bounds
        
        self.logo.backgroundColor = UIColor.clear
        self.logo.bounds = CGRect(x:0, y:0, width:self.bounds.size.width, height:50)
        self.logo.center = CGPoint(x:self.mj_w * 0.5, y:-30)
        
        self.loading.center = CGPoint(x:self.mj_w - 30, y:self.mj_h * 0.5)
    }
    
    override var state: MJRefreshState{
        didSet
        {
            switch (state) {
            case MJRefreshState.idle:
                self.loading.stopAnimating()
                self.label.text = "下拉刷新"
                break
            case MJRefreshState.pulling:
                self.loading.stopAnimating()
                self.label.text = "松开加载"
                break
            case MJRefreshState.refreshing:
                self.label.text = "加载数据中"
                self.loading.startAnimating()
                break
            default:
                break
            }
        }
    }
    //监听scrollView的contentOffset改变
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    //监听scrollView的contentSize改变
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    //监听scrollView的拖拽状态改变
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }

    
    
}
