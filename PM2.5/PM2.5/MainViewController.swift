//
//  MainViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/1/22.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import PKHUD
import MJRefresh

class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var scoreView: UIScrollView!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    @IBOutlet weak var pm25image: UIImageView!
    @IBOutlet weak var pm25: UILabel!
    @IBOutlet weak var pm10: UILabel!
    @IBOutlet weak var so2: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var o3: UILabel!
    @IBOutlet weak var co: UILabel!
    
    let arrowWidth = 35
    let arrowHight = 35
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let path = Bundle.main.path(forResource: "pm25", ofType: "json")
        let jsonData = NSData.init(contentsOfFile: path!)
        let json = JSON(jsonData!)
        initLocationManager()
        updateUI(json: json)
        
        ceateHeader()
        // Do any additional setup after loading the view.
    }
    
    func updateUI(json: JSON) {
        let pm25 = CommonTool.getAverageNum(json: json, string: "pm2_5")
        self.pm25.text = String(pm25)
        let distence = CommonTool.pm25ChangeIntoFrame(pm25: pm25)
        self.updateArrow(locationX: (Int(self.view.frame.midX) - 100  - arrowWidth/2 + distence), locationY: Int(pm25image.frame.origin.y) - Int(Double(arrowHight)/1.7))
    }
    
    func ceateHeader() {
        let header = MJDIYHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.scoreView.mj_header = header
    }
    
    func headerRefresh() {
//        let path = Bundle.main.path(forResource: "pm10", ofType: "json")
//        let jsonData = NSData.init(contentsOfFile: path!)
//        let json = JSON(jsonData!)
//        self.updateUI(json: json)
        print("重新获得pm25的值是")
    }
    
    
    /// 根据pm2.5更新箭头的位置
    func updateArrow(locationX: Int, locationY: Int) {
        let imageView = UIImageView(image:UIImage(named:"arrow2"))
        imageView.frame = CGRect(x:locationX, y:locationY, width:35, height:35)
        self.scoreView.addSubview(imageView)
    }
    
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let newLocation: CLLocation? = locations.last
        let locationAge: TimeInterval = -(newLocation?.timestamp.timeIntervalSinceNow)!
        if locationAge.binade > 1.0 {
            //如果调用已经一次，不再执行
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if let pm = placemarks?[0] {
                self.displayLocationInfo(placemark: pm)
            } else {
                self.showHub(text: "获得地理位置失败...")
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func showHub(text: String) {
        // 这里面又一个warning https://github.com/pkluz/PKHUD/issues/6 fixed
        let hud = PKHUD()
        hud.contentView = PKHUDTextView(text: text)
        hud.show()
        hud.hide(afterDelay: 1.0)
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            locationManager.stopUpdatingLocation()
            
            let place = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            self.userLocationLabel.text = "\(place!), \(locality!), \(country!)"
        }
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
