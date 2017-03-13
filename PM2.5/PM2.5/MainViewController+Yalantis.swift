//
//  MainViewController+Yalantis.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/13.
//  Copyright © 2017年 童小托. All rights reserved.
//

import SideMenu


extension MainViewController: MenuViewControllerDelegate {
    func menu(_: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {
        if index == 1 {
            let shareParames = NSMutableDictionary()
            shareParames.ssdkSetupShareParams(byText: "测试PM2.5数据",
                                              images : UIImage(named: "defaultCloud"),
                                              url : NSURL(string:"https://pm25.date") as URL!,
                                              title : "测试标题",
                                              type : SSDKContentType.auto)
            
            shareParames.ssdkEnableUseClientShare()
            // 自定义分享菜单
            SSUIShareActionSheetStyle.setCancelButtonLabel(UIColor.flatBlack)
            SSUIShareActionSheetStyle.setItemNameColor(UIColor.flatBlack)
            SSUIShareActionSheetStyle.setItemNameFont(UIFont.boldSystemFont(ofSize: 10))
            
            
            let items: [Any] = [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.subTypeWechatSession.rawValue,
                SSDKPlatformType.subTypeWechatTimeline.rawValue,
                SSDKPlatformType.subTypeQQFriend.rawValue,
                SSDKPlatformType.subTypeQZone.rawValue
            ]
            
            let sheet: SSUIShareActionSheetController = ShareSDK.showShareActionSheet(self.detailButton, items: items, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userData : [AnyHashable : Any]?, entity : SSDKContentEntity?, error: Error?, end: Bool) in
                
                switch state{
                case SSDKResponseState.success:
                    self.showHub(text: "分享成功")
                case SSDKResponseState.fail:    print("分享失败,错误描述:\(error)")
                case SSDKResponseState.cancel:  print("分享取消")
                self.showHub(text: "分享取消")
                default:
                    break
                }
            }
            // 不跳转编辑页面
            sheet.directSharePlatforms.add(SSDKPlatformType.typeSinaWeibo.rawValue)

        }
        if index == 2 {
            print("点击了第二个")
        }
        if index == 3 {
            print("点击了第三个")
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func menuDidCancel(_: MenuViewController) {
        dismiss(animated: true, completion: nil)
    }
}


extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}

//    @IBAction func shareButton(_ sender: Any) {
//
//        let shareParames = NSMutableDictionary()
//        shareParames.ssdkSetupShareParams(byText: "测试PM2.5数据",
//                                          images : UIImage(named: "defaultCloud"),
//                                          url : NSURL(string:"https://pm25.date") as URL!,
//                                          title : "测试标题",
//                                          type : SSDKContentType.auto)
//
//        shareParames.ssdkEnableUseClientShare()
//        // 自定义分享菜单
//        SSUIShareActionSheetStyle.setCancelButtonLabel(UIColor.flatBlack)
//        SSUIShareActionSheetStyle.setItemNameColor(UIColor.flatBlack)
//        SSUIShareActionSheetStyle.setItemNameFont(UIFont.boldSystemFont(ofSize: 10))
//
//
//        let items: [Any] = [
//            SSDKPlatformType.typeSinaWeibo.rawValue,
//            SSDKPlatformType.subTypeWechatSession.rawValue,
//            SSDKPlatformType.subTypeWechatTimeline.rawValue,
//            SSDKPlatformType.subTypeQQFriend.rawValue,
//            SSDKPlatformType.subTypeQZone.rawValue
//        ]
//
//        let sheet: SSUIShareActionSheetController = ShareSDK.showShareActionSheet(shareButton, items: items, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userData : [AnyHashable : Any]?, entity : SSDKContentEntity?, error: Error?, end: Bool) in
//
//            switch state{
//            case SSDKResponseState.success:
//                self.showHub(text: "分享成功")
//            case SSDKResponseState.fail:    print("分享失败,错误描述:\(error)")
//            case SSDKResponseState.cancel:  print("分享取消")
//            self.showHub(text: "分享取消")
//            default:
//                break
//            }
//        }
//        // 不跳转编辑页面
//        sheet.directSharePlatforms.add(SSDKPlatformType.typeSinaWeibo.rawValue)
//    }
