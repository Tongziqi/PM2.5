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
    
    var detailWeatherDate: [String: String] = [:]
    let detailWeatherView: DetailWeatherView = (Bundle.main.loadNibNamed("DetailWeatherView", owner: nil, options: nil)?.first as? DetailWeatherView)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewWidth: CGFloat = 190
        let viewHeigth: CGFloat = 360
        let parentSize = ScreenBounds
        let x = (parentSize.width - viewWidth) / 2
        let y = (parentSize.height - viewHeigth) / 2
        setDefaultData()
        detailWeatherView.layer.cornerRadius = 20
        detailWeatherView.layer.masksToBounds = true
        detailWeatherView.backgroundColor = UIColor.flatBlack
        detailWeatherView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeigth)

        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        self.view.addSubview(detailWeatherView)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(bgOnTap)))
    }
    
    func setDefaultData() {
        detailWeatherView.activityState.text = detailWeatherDate["activityState"]
        detailWeatherView.aqi.text = detailWeatherDate["aqi"]
        detailWeatherView.data.text = detailWeatherDate["data"]
        detailWeatherView.city.text = detailWeatherDate["city"]
        detailWeatherView.weather.text = detailWeatherDate["weather"]
        detailWeatherView.tempoture.text = detailWeatherDate["tempoture"]
        detailWeatherView.currentTemputure.text = detailWeatherDate["currentTemputure"]
        detailWeatherView.humidity.text = detailWeatherDate["humidity"]?.components(separatedBy: "湿度：").last
        if detailWeatherDate["windDirection"] != "" {
            detailWeatherView.windDirection.text = detailWeatherDate["windDirection"]
        } else {
            detailWeatherView.windDirection.text = "未获得风向"

        }
        detailWeatherView.weatherState.text = detailWeatherDate["weatherState"]
        detailWeatherView.dressingIndex.text = detailWeatherDate["dressingIndex"]
        detailWeatherView.week.text = detailWeatherDate["week"]
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
