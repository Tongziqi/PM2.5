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
        let firstPage = OnboardingContentViewController.content(withTitle: "Welcome To pm2.5", body: "啦啦啦的pm2.5", image: UIImage(named: "onboard"), buttonText: nil, action: nil)
        let secondPage = OnboardingContentViewController.content(withTitle: "Step 1", body: "第一页", image: UIImage(named: "onboard"), buttonText: nil, action: nil)
        let thirdPage = OnboardingContentViewController.content(withTitle: "Step 2", body: "第二页", image: UIImage(named: "onboard"), buttonText: nil, action: nil)
        let fourthPage = OnboardingContentViewController.content(withTitle: "Step 3", body: "第三页", image: UIImage(named: "onboard"), buttonText: "点击开始", action: self.skip)
        // Define onboarding view controller properties
        onboardVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "boardingImg"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        onboardVC.shouldFadeTransitions = true
        onboardVC.shouldMaskBackground = true
        onboardVC.shouldBlurBackground = false
        onboardVC.fadePageControlOnLastPage = true
        onboardVC.pageControl.pageIndicatorTintColor = UIColor.darkGray
        onboardVC.pageControl.currentPageIndicatorTintColor = UIColor.white
        onboardVC.skipButton.setTitleColor(UIColor.black, for: .normal)
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
