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
import IGListKit

class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var labelSize: NSLayoutConstraint!
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
    var arrLocationY: Int?
    let locationTag = 99
    
    var locationManager: CLLocationManager!
    var currentLocation: String = "获取地理位置失败"
    var searchLocation: String = ""
    
    
    let loader = ForecastDataLoader()
    let collectionView = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var data = ["beijing"] as [Any]
    var forecastJson: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 适配
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        arrLocationY = Int(pm25image.frame.origin.y) - Int(Double(arrowHight)/1.7)
        switch screenHeight {
        case 480.0:
            labelSize.constant = 30
            arrLocationY = arrLocationY! - 20
        case 568.0:
            labelSize.constant = 40
            arrLocationY = arrLocationY! - 10
        case 667.0:
            labelSize.constant = 50
        case 736.0:
            labelSize.constant = 50
        default:
            break
        }
        
        // 准备添加分享功能
        
        self.locationImg.isHidden = true
        initLocationManager()
        ceateHeader()
        // Do any additional setup after loading the view.
        
        self.scoreView.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = UIColor.clear
        adapter.dataSource = self
        
        data = [self.searchLocation] as [Any]
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: self.view.bounds.height - 150, width: self.view.bounds.width, height: 70)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func jumpToChoose(_ sender: Any) {
        let chooseViewController = ChooseViewController(nibName: "ChooseViewController", bundle: nil)
        let vc = UINavigationController(rootViewController: chooseViewController)
        
        chooseViewController.locationCity = self.currentLocation
        chooseViewController.setBackMyClosure { (input: String) in
            self.userLocationLabel.text = input
            self.locationImg.isHidden = true
            self.searchLocation = input
            self.updateWeather(location: input)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "测试PM2.5数据",
                                          images : UIImage(named: "defaultCloud"),
                                          url : NSURL(string:"https://tongxiaotuo.me") as URL!,
                                          title : "测试标题",
                                          type : SSDKContentType.auto)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
            case SSDKResponseState.success:
                print("分享成功")
                self.showHub(text: "分享成功")
            case SSDKResponseState.fail:
                print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:
                print("操作取消")
                self.showHub(text: "操作取消")
            default:
                break
            }
        }
    }
    
    func updateWeather(location: String) {
        HUD.show(.progress)
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
                    self?.updateWeatherUI(json: json)
                }
                self?.updatePm25(location: location)
            case .failure(let errno):
                HUD.hide()
                self?.showHub(text: "实时数据获取失败")
                print(errno)
            }
        }
        
    }
    
    func updatePm25(location: String) {
        let parameters: Parameters = ["app":"weather.pm25",
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
                    self?.updatePM25UI(json: json)
                }
                self?.updataForecastWeather(location: location)
            case .failure(let errno):
                HUD.hide()
                self?.showHub(text: "pm2.5数据获取失败")
                print(errno)
            }
        }
    }
    
    func updataForecastWeather(location: String) {
        let parameters: Parameters = ["app":"weather.future",
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
                    self?.forecastJson = json
                    self?.updateForecastUI(json: json)
                }
            case .failure(let errno):
                HUD.hide()
                self?.showHub(text: "未来天气数据获取失败")
                print(errno)
            }
        }
        
    }
    
    func updateForecastUI(json: JSON) {
        data.remove(at: 0)
        //这里面生成一个随机数，保证每次获得的都不一样
        data.append(self.searchLocation + String(arc4random()))
        self.scoreView.reloadInputViews()
        self.adapter.performUpdates(animated: true, completion: nil)
        HUD.hide()
        self.showHub(text: self.searchLocation + "数据更新完毕")
        
    }
    
    
    
    func updatePM25UI(json: JSON) {
        let aqi: String = json["result"]["aqi"].stringValue
        self.pm25.text = aqi
        let aqi_int = Int.init(aqi)
        //self.scoreView.reloadInputViews()
        let distence = CommonTool.pm25ChangeIntoFrame(pm25: aqi_int!)
        self.updateArrow(locationX: (Int(self.view.frame.midX) - 100  - arrowWidth/2 + distence), locationY: self.arrLocationY!)
    }
    
    
    func updateWeatherUI(json: JSON) {
        let weatherLabel: String = json["result"]["days"].stringValue + "\n" + json["result"]["weather"].stringValue + " " + json["result"]["temperature"].stringValue
        let weather_curr: String = json["result"]["weather_curr"].stringValue
        self.weatherImage.image = UIImage(named: weather_curr)
        self.weatherLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.weatherLabel.font = UIFont(name: "Helvetica", size: 18)
        self.weatherLabel.text = weatherLabel
        
    }
    
    
    
    
    func ceateHeader() {
        self.scoreView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
    }
    
    func headerRefresh() {
        print("重新获得pm25的值是")
        if self.searchLocation != "" {
            self.updateWeather(location: self.searchLocation)
        }
        self.scoreView.mj_header.endRefreshing()
    }
    
    
    /// 根据pm2.5更新箭头的位置
    func updateArrow(locationX: Int, locationY: Int) {
        let imageView = UIImageView(image:UIImage(named:"arrow2"))
        imageView.frame = CGRect(x:locationX, y:locationY, width:35, height:35)
        imageView.tag = self.locationTag
        for subView in self.scoreView.subviews {
            if subView.tag == self.locationTag {
                subView.removeFromSuperview()
            }
        }
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
            self.searchLocation = currentLocation
            self.updateWeather(location: self.currentLocation)
        }
    }
    
}

extension MainViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        //这个不是有几行，而是类似的一个 key，如果有不一样的key，就添加一行，本文用搜索的城市名作为key
        return data as! [IGListDiffable]
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return HorizontalSectionController(json: forecastJson)
    }
    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}
