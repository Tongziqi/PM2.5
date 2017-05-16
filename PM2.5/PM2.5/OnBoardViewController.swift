//
//  onBoardViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/5/16.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Onboard


class OnBoardViewControllerTool {
    static var onboardVC = OnboardingViewController()
    
    static func generateStandardOnboardingVC() -> OnboardingViewController {
        // Create slides
        let firstPage = OnboardingContentViewController.content(withTitle: "欢迎使用Pm2.5和天气", body: "苍穹之下，我们能做什么", image: UIImage(named: ""), buttonText: nil, action: nil)
        firstPage.titleLabel.font = UIFont.systemFont(ofSize: 20)
        firstPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        firstPage.bodyLabel.textColor = UIColor.flatRed
        firstPage.topPadding = 0
        firstPage.underTitlePadding = 200
        let secondPage = OnboardingContentViewController.content(withTitle: "", body: "", image: UIImage(named: "onborad2"), buttonText: nil, action: nil)
        secondPage.topPadding = 0
        secondPage.underTitlePadding = 200
        secondPage.iconWidth = ScreenWidth
        secondPage.iconHeight = ScreenHeight
        let thirdPage = OnboardingContentViewController.content(withTitle: "", body: "", image: UIImage(named: "onborad4"), buttonText: nil, action: nil)
        thirdPage.topPadding = 0
        thirdPage.underTitlePadding = 200
        thirdPage.iconWidth = ScreenWidth
        thirdPage.iconHeight = ScreenHeight
        let fourthPage = OnboardingContentViewController.content(withTitle: "", body: "", image: UIImage(named: "onborad3"), buttonText: "开始使用", action: self.skip)
        fourthPage.topPadding = 0
        fourthPage.underTitlePadding = 200
        fourthPage.iconWidth = ScreenWidth
        fourthPage.iconHeight = ScreenHeight
        fourthPage.actionButton.setTitleColor(UIColor.flatWhite, for: .normal)
        // Define onboarding view controller properties
        onboardVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "pm25"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        //淡入淡出效果
        onboardVC.shouldFadeTransitions = true
        // 背景
        onboardVC.shouldMaskBackground = true
        // 虚化背景
        onboardVC.shouldBlurBackground = false
        onboardVC.fadePageControlOnLastPage = true
        
        onboardVC.skipButton.setTitle("Let's Go!", for: .normal)
        onboardVC.skipButton.setTitleColor(UIColor.gray, for: .normal)
        
        onboardVC.allowSkipping = true
        onboardVC.fadeSkipButtonOnLastPage = true
        onboardVC.skipHandler = {
            self.skip()
        }
        return onboardVC
    }
    
    
    static func setupNormalRootViewController (){
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    static func skip (){
        if VersionControl.checkIsRealFirstUse() {
            self.setupNormalRootViewController()
        } else {
            self.onboardVC.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
