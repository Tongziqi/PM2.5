//
//  DeatilViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/3/15.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import ChameleonFramework

class DeatilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView: UIView = (Bundle.main.loadNibNamed("DetailWeatherView", owner: nil, options: nil)?.first as? DetailWeatherView)!
        
        let viewWidth: CGFloat = 190
        let viewHeigth: CGFloat = 320
        let parentSize = ScreenBounds
        let x = (parentSize.width - viewWidth) / 2
        let y = (parentSize.height - viewHeigth) / 2
        
        testView.layer.cornerRadius = 20
        testView.layer.masksToBounds = true
        testView.backgroundColor = UIColor.flatBlack
        testView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeigth)

        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        self.view.addSubview(testView)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(bgOnTap)))
    }
    
    override func loadView() {
        super.loadView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bgOnTap(_gusture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
