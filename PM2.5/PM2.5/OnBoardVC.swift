//
//  onBoard.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/23.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Onboard

extension AppDelegate {
        func generateStandardOnboardingVC() -> OnboardingViewController {
        var onboardVC = OnboardingViewController()
        // Create slides
        let firstPage = OnboardingContentViewController.content(withTitle: "Welcome To pm2.5", body: "苍穹之下，我们能做什么", image: UIImage(named: ""), buttonText: nil, action: nil)
            firstPage.topPadding = 0
            firstPage.underTitlePadding = 200
        let secondPage = OnboardingContentViewController.content(withTitle: "Step 1", body: "第一页", image: UIImage(named: ""), buttonText: nil, action: nil)
            secondPage.topPadding = 0
            secondPage.underTitlePadding = 200
        let thirdPage = OnboardingContentViewController.content(withTitle: "Step 2", body: "第二页", image: UIImage(named: ""), buttonText: nil, action: nil)
            thirdPage.topPadding = 0
            thirdPage.underTitlePadding = 200
        let fourthPage = OnboardingContentViewController.content(withTitle: "Step 3", body: "第三页", image: UIImage(named: ""), buttonText: "点击开始", action: self.skip)
            fourthPage.topPadding = 0
            fourthPage.underTitlePadding = 200
            fourthPage.actionButton.setTitleColor(UIColor.cyan, for: .normal)
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
    
     func setupNormalRootViewController (){
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }

     func skip (){
        self.setupNormalRootViewController()
    }
    
}
