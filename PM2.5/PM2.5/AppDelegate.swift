//
//  AppDelegate.swift
//  PM2.5
//
//  Created by 童小托 on 2017/1/22.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Reachability
import PKHUD


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var reach: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        buildOnboard()
        registerShareSDK()
        initReachability()
        // 友盟统计
        addUmengAnalytics()
        // Override point for customization after application launch.
        return true
    }
    
    func addUmengAnalytics() {
        let analyticsConfig = UMAnalyticsConfig.sharedInstance()
        analyticsConfig?.appKey = "58ed0329734be4399900260d"
        MobClick.start(withConfigure: analyticsConfig)
    }
    
    
    func initReachability() {
        if reach == nil {
            reach = Reachability.forInternetConnection()
            self.reach!.reachableOnWWAN = false
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
            reach?.startNotifier()
        }
    }
    
    func reachabilityChanged(notification: NSNotification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            let text = "网络连接已恢复"
            let hud = PKHUD()
            hud.contentView = PKHUDTextView(text: text)
            hud.show()
            hud.hide(afterDelay: 1.0)
        } else {
            let text = "网络连接已断开"
            let hud = PKHUD()
            hud.contentView = PKHUDTextView(text: text)
            hud.show()
            hud.hide(afterDelay: 1.0)
        }
    }

    func registerShareSDK() {
        ShareSDK.registerApp("1bea6cb22f93c",
                             activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue,
                                               SSDKPlatformType.typeQQ.rawValue,
                                               SSDKPlatformType.subTypeWechatTimeline.rawValue,
                                               SSDKPlatformType.subTypeWechatSession.rawValue],
                             onImport: {(platform : SSDKPlatformType) -> Void in
                                switch platform{
                                case SSDKPlatformType.typeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
        },
                             onConfiguration: {(platform ,appInfo) -> Void in
                                switch platform {
                                case SSDKPlatformType.typeSinaWeibo:
                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "3002096572",
                                                                appSecret : "334c0245b2824769cfb89516bd81e645",
                                                                redirectUri : "https://www.sharesdk.cn",
                                                                authType: SSDKAuthTypeBoth)
                                    break
                                case SSDKPlatformType.typeWechat:
                                    //设置微信应用信息
                                    appInfo?.ssdkSetupWeChat(byAppId: "wx9f631c284d30ab79", appSecret: "334c0245b2824769cfb89516bd81e645")
                                    break
                                    
                                case SSDKPlatformType.typeQQ:
                                    appInfo?.ssdkSetupQQ(byAppId: "1105958311", appKey: "n1r4j6MnvYJR3Du5", authType:  SSDKAuthTypeBoth)
                                    break
                                    
                                default:
                                    break
                                    
                                }
        })
    }
    
    func buildOnboard() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        let needOnBoard = VersionControl.checkIsRealFirstUse()
        let vc = OnBoardViewControllerTool.generateStandardOnboardingVC()
        if needOnBoard {
            window?.rootViewController = vc
        } else {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()

        }
    }
    

    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

