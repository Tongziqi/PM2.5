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

class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var userLocationLabel: UILabel!
    
    @IBOutlet weak var pm25: UILabel!
    @IBOutlet weak var pm10: UILabel!
    @IBOutlet weak var so2: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var o3: UILabel!
    @IBOutlet weak var co: UILabel!
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "pm25", ofType: "json")
        let jsonData = NSData.init(contentsOfFile: path!)
        let json = JSON(jsonData!)
        initLocationManager()
        updateUI(json: json)
        
        // Do any additional setup after loading the view.
    }
    
    func updateUI(json: JSON) {
        pm25.text = String(CommonTool.getAverageNum(json: json, string: "pm2_5"))
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            let pm = placemarks![0]
            self.displayLocationInfo(placemark: pm)
        }
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
