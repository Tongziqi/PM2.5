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
import Alamofire

class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var scoreView: UIScrollView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var locationImg: UIButton!
    
    //Weather
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    //PM2.5
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
    var currentLocation: String = "获取地理位置失败"
    var searchLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationImg.isHidden = true
        let path = Bundle.main.path(forResource: "pm25", ofType: "json")
        let jsonData = NSData.init(contentsOfFile: path!)
        let json = JSON(jsonData!)
        initLocationManager()
        updatePM25UI(json: json)
        ceateHeader()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func jumpToChoose(_ sender: Any) {
        let vc = ChooseViewController(nibName: "ChooseViewController", bundle: nil)
        vc.locationCity = self.currentLocation
        vc.setBackMyClosure { (input: String) in
            self.userLocationLabel.text = input
            self.locationImg.isHidden = true
            self.searchLocation = input
            self.updateWeatherUI(location: input)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func updatePM25UI(json: JSON) {
        let pm25 = CommonTool.getAverageNum(json: json, string: "pm2_5")
        self.pm25.text = String(pm25)
        let distence = CommonTool.pm25ChangeIntoFrame(pm25: pm25)
        self.updateArrow(locationX: (Int(self.view.frame.midX) - 100  - arrowWidth/2 + distence), locationY: Int(pm25image.frame.origin.y) - Int(Double(arrowHight)/1.7))
    }
    
    func updateWeatherUI(location: String) {
        let parameters: Parameters = ["app":"weather.today",
                                      "format":"json",
                                      "appkey":UserSetting.Appkey,
                                      "sign":UserSetting.Sign,
                                      "weaid":location]
        Alamofire.request(UserSetting.WeatherTodayUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { [weak self] (response) in
            guard self != nil else { return }
            switch response.result {
            case .success:
                if let value = response.result.value{
                    let json = JSON(value)
                    self?.updateWeather(json: json)
                }
            case .failure(let errno):
                print(errno)
            }
        }
    }
    
    
    func updateWeather(json: JSON) {
        let testWeatherLabel: String = json["result"]["days"].stringValue + "\n" + json["result"]["weather"].stringValue + " " + json["result"]["temperature"].stringValue
        self.weatherLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.weatherLabel.font = UIFont(name: "Helvetica", size: 18)
        self.weatherLabel.text = testWeatherLabel
        self.scoreView.reloadInputViews()
        self.showHub(text: self.searchLocation + "数据更新完毕")
    }
    
    
    func ceateHeader() {
        self.scoreView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
    }
    
    func headerRefresh() {
        print("重新获得pm25的值是")
        self.updateWeatherUI(location: self.searchLocation)
        self.scoreView.mj_header.endRefreshing()
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
    
    //可以添加那里一些限制。比如位置和精度之间的时间跨度。来解决多次调用
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
            //let place = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            var locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            //let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            if locality == "北京市" {
                locality = "北京"
            }
            self.currentLocation = "\(locality!)"
            self.locationImg.isHidden = false
            
            self.userLocationLabel.text = currentLocation
            self.updateWeatherUI(location: self.currentLocation)
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
