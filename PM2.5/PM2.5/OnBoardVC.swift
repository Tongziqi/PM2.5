//
//  onBoard.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/23.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import Onboard

class OnBoardVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize onboarding view controller
        var onboardVC = OnboardingViewController()
        // Create slides
        let firstPage = OnboardingContentViewController.content(withTitle: "Welcome To pm2.5", body: "啦啦啦的pm2.5", image: UIImage(named: "boardingImg"), buttonText: nil, action: nil)
        let secondPage = OnboardingContentViewController.content(withTitle: "Step 1", body: "第一页", image: UIImage(named: "boardingImg"), buttonText: nil, action: nil)
        let thirdPage = OnboardingContentViewController.content(withTitle: "Step 2", body: "第二页", image: UIImage(named: "boardingImg"), buttonText: nil, action: nil)
        let fourthPage = OnboardingContentViewController.content(withTitle: "Step 3", body: "第三页", image: UIImage(named: "boardingImg"), buttonText: nil, action: nil)
        // Define onboarding view controller properties
        onboardVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "boardingImg"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        onboardVC.shouldFadeTransitions = true
        onboardVC.shouldMaskBackground = false
        onboardVC.shouldBlurBackground = false
        onboardVC.fadePageControlOnLastPage = true
        onboardVC.pageControl.pageIndicatorTintColor = UIColor.darkGray
        onboardVC.pageControl.currentPageIndicatorTintColor = UIColor.white
        onboardVC.skipButton.setTitleColor(UIColor.black, for: .normal)
        onboardVC.allowSkipping = false
        onboardVC.fadeSkipButtonOnLastPage = true
        
        // Present presentation
        self.present(onboardVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
