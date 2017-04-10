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
import Reachability
import Foundation


class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
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
    @IBOutlet weak var aqi: UILabel!
    @IBOutlet weak var airConditon: UILabel!
    
    
    let arrowWidth = 35
    let arrowHight = 35
    var arrLocationY: Int?
    var collectionViewHeight: CGFloat? = 150
    let locationTag = 99
    
    var locationManager: CLLocationManager!
    var currentLocation: String = "获取地理位置失败"
    var searchLocation: String = ""
    var detailWeather: [String:String] = [:]
    var dayOfAqiJson: JSON = []
    var updateTime: String = ""
    
    
    let loader = ForecastDataLoader()
    let collectionView = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    // 数据源
    var data = ["beijing"] as [Any]
    var forecastJson: JSON = []
    
    //读取全部的city，预更新
    var cities = [City]()
    
    var choosedCities:[String: ChoosedCity] = [:]
    
    
    
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
            collectionViewHeight = 100
        case 568.0:
            labelSize.constant = 40
            arrLocationY = arrLocationY! - 10
            collectionViewHeight = 120
        case 667.0:
            labelSize.constant = 50
        case 736.0:
            labelSize.constant = 50
        default:
            break
        }
        self.locationImg.isHidden = true
        
        cities = CommonTool.loadData(cities: &cities)
        
        initLocationManager()
        ceateHeader()
        // Do any additional setup after loading the view.
        
        self.scoreView.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = UIColor.clear
        adapter.dataSource = self
        
        data = [self.searchLocation] as [Any]
        
        checkNetConnection()
        addTouchListener()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkNetConnection), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    // 监听后台进入，刷新页面
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    func refresh() {
        initLocationManager()
        if self.currentLocation != "获取地理位置失败" {
            self.updateWeather(location: self.currentLocation)
        }
    }
    
    
    func addTouchListener() {
        weatherImage.isUserInteractionEnabled = true
        weatherLabel.isUserInteractionEnabled = true
        
        pm25image.isUserInteractionEnabled = true
        pm10.isUserInteractionEnabled = true
        so2.isUserInteractionEnabled = true
        no2.isUserInteractionEnabled = true
        aqi.isUserInteractionEnabled = true
        airConditon.isUserInteractionEnabled = true
        pm25.isUserInteractionEnabled = true
        
        weatherImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedDeatilWeather)))
        weatherLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedDeatilWeather)))
        
        pm25image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        pm25.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        pm10.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        so2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        no2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        aqi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
        airConditon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAqiDeatil)))
    }
    
    func tappedDeatilWeather() {
        let deatilViewController = DeatilViewController()
        deatilViewController.detailWeatherDate = self.detailWeather
        deatilViewController.modalPresentationStyle = UIModalPresentationStyle.custom
        deatilViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(deatilViewController, animated: true, completion: nil)
    }
    
    func tappedAqiDeatil() {
        let tableViewController = TableViewController()
        tableViewController.json = self.dayOfAqiJson
        tableViewController.modalPresentationStyle = UIModalPresentationStyle.custom
        tableViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(tableViewController, animated: true, completion: nil)
    }
    
    
    func checkNetConnection() {
        let reachability = Reachability.forInternetConnection()
        
        let isReachable  = reachability?.isReachable() ?? false
        
        if !isReachable {
            let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            //使用kvc更改UIAlertController 富文本
            let alertControllerTitleStr: NSMutableAttributedString = NSMutableAttributedString(string: "提示")
            alertControllerTitleStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.flatBlack, range: NSRange(location: 0, length: alertControllerTitleStr.length))
            alertController.setValue(alertControllerTitleStr, forKey: "attributedTitle")
            
            let alertControllerMessageStr: NSMutableAttributedString = NSMutableAttributedString(string: "当前网络不可用，请检查您的网络设置。\n1）Wifi 或 移动蜂窝网络是否打开。\n2)【设置】-【MyPM2.5】中网络设置是否打开。")
            alertControllerMessageStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.flatBlack, range: NSRange(location: 0, length: alertControllerMessageStr.length))
            alertControllerMessageStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: CGFloat(12)), range: NSRange(location: 0, length: alertControllerMessageStr.length))
            let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.left
            alertControllerMessageStr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: alertControllerMessageStr.length))
            alertController.setValue(alertControllerMessageStr, forKey: "attributedMessage")
            
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            cancelAction.setValue(UIColor.flatBlack, forKey: "titleTextColor")
            
            let okAction = UIAlertAction(title: "去设置", style: UIAlertActionStyle.default, handler: { (action : UIAlertAction) in
                let url = URL(string:UIApplicationOpenSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) == true {
                    UIApplication.shared.openURL(url!)
                }
            })
            okAction.setValue(UIColor.flatBlack, forKey: "titleTextColor")
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: self.view.bounds.height - self.collectionViewHeight!, width: self.view.bounds.width, height: 70)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func jumpToChoose(_ sender: Any) {
        let chooseViewController = ChooseViewController(nibName: "ChooseViewController", bundle: nil)
        chooseViewController.locationCity = self.currentLocation
        chooseViewController.choosedCities = self.choosedCities
        chooseViewController.setBackMyClosure { (input: String) in
            self.userLocationLabel.text = input
            self.locationImg.isHidden = true
            self.searchLocation = input
            
            delay(0.5, task: {
                self.updateWeather(location: input)
            })
            
        }
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: chooseViewController)
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuRightNavigationController = menuLeftNavigationController
        SideMenuManager.menuShadowColor =  UIColor.clear
        SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: self.searchLocation + "的PM2.5数据为:" + self.weatherLabel.text!,
                                          images : UIImage(named: "defaultCloud"),
                                          url : NSURL(string:"https://pm25.date") as URL!,
                                          title : self.searchLocation + "的PM2.5数据",
                                          type : SSDKContentType.auto)
        
        shareParames.ssdkEnableUseClientShare()
        // 自定义分享菜单
        SSUIShareActionSheetStyle.setCancelButtonLabel(UIColor.flatBlack)
        SSUIShareActionSheetStyle.setItemNameColor(UIColor.flatBlack)
        SSUIShareActionSheetStyle.setItemNameFont(UIFont.boldSystemFont(ofSize: 10))
        
        
        let items: [Any] = [
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.subTypeWechatSession.rawValue,
            SSDKPlatformType.subTypeWechatTimeline.rawValue,
            SSDKPlatformType.subTypeQQFriend.rawValue,
            SSDKPlatformType.subTypeQZone.rawValue
        ]
        
        let sheet: SSUIShareActionSheetController = ShareSDK.showShareActionSheet(shareButton, items: items, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userData : [AnyHashable : Any]?, entity : SSDKContentEntity?, error: Error?, end: Bool) in
            
            switch state{
            case SSDKResponseState.success:
                self.showHub(text: "分享成功")
            case SSDKResponseState.fail:    print("分享失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("分享取消")
            self.showHub(text: "分享取消")
            default:
                break
            }
        }
        // 不跳转编辑页面
        sheet.directSharePlatforms.add(SSDKPlatformType.typeSinaWeibo.rawValue)
    }
    
    
    
    func updateWeather(location: String) {
        HUD.show(.progress)
        //清空一下缓存
        self.choosedCities.removeAll()
        
        let parameters: Parameters = ["key":UserSetting.newAppkey,
                                      "city":location]
        Alamofire.request(UserSetting.newWeatherUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { [weak self] (response) in
            guard self != nil else { return }
            HUD.hide()
            
            switch response.result {
            case .success:
                if let value = response.result.value{
                    let json = JSON(value)
                    let choosedCity: ChoosedCity = ChoosedCity.init(city: location, weather: getRealWeather(json: json), temperature: json["result"][0]["temperature"].stringValue, wind: json["result"][0]["wind"].stringValue)
                    self?.updateTime = json["result"][0]["updateTime"].stringValue
                    self?.addDetailWeatherFromJson(json: json)
                    self?.choosedCities[location] = choosedCity
                    self?.updateWeatherUI(json: json)
                    let futurejson: JSON = json["result"][0]["future"]
                    self?.forecastJson = futurejson
                }
                self?.updatePm25(location: location)
            case .failure(let errno):
                HUD.hide()
                self?.showHub(text: "实时数据获取失败")
                print(errno)
            }
        }
        
    }
    
    
    func addDetailWeatherFromJson(json: JSON) {
        detailWeather["data"] = json["result"][0]["date"].stringValue
        detailWeather["city"] = json["result"][0]["city"].stringValue
        detailWeather["weather"] = getRealWeather(json: json)
        detailWeather["tempoture"] = json["result"][0]["future"][0]["temperature"].stringValue
        detailWeather["currentTemputure"] = json["result"][0]["temperature"].stringValue
        detailWeather["windDirection"] = json["result"][0]["wind"].stringValue
        detailWeather["aqi"] = json["result"][0]["pollutionIndex"].stringValue
        detailWeather["humidity"] = json["result"][0]["humidity"].stringValue
        detailWeather["weatherState"] = json["result"][0]["airCondition"].stringValue
        detailWeather["activityState"] = json["result"][0]["exerciseIndex"].stringValue
        detailWeather["dressingIndex"] = json["result"][0]["dressingIndex"].stringValue
    }
    
    func updatePm25(location: String) {
        let parameters: Parameters = ["key":UserSetting.newAppkey,
                                      "city":location]
        Alamofire.request(UserSetting.newAqiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { [weak self] (response) in
            guard self != nil else { return }
            switch response.result {
            case .success:
                if let value = response.result.value{
                    let json = JSON(value)
                    self?.dayOfAqiJson = json
                    self?.updatePM25UI(json: json)
                }
                self?.updateForecastUI(json: (self?.forecastJson)!)
                
            case .failure(let errno):
                HUD.hide()
                self?.showHub(text: "pm2.5数据获取失败")
                print(errno)
            }
        }
        self.updateChoosedCity(citys: (self.cities))
    }
    
    
    func updateChoosedCity(citys: [City]) {
        
        if self.currentLocation != "获取地理位置失败" {
            let parameters: Parameters = ["key":UserSetting.newAppkey,
                                          "city":self.currentLocation]
            Alamofire.request(UserSetting.newWeatherUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { [weak self] (response) in
                guard self != nil else { return }
                switch response.result {
                case .success:
                    if let value = response.result.value{
                        let json = JSON(value)
                        let choosedCity: ChoosedCity = ChoosedCity.init(city: self!.currentLocation, weather: getRealWeather(json: json), temperature: json["result"][0]["temperature"].stringValue, wind: json["result"][0]["wind"].stringValue)
                        self?.choosedCities[(self?.currentLocation)!] = choosedCity
                    }
                case .failure(let errno):
                    HUD.hide()
                    self?.showHub(text: "实时数据获取失败")
                    print(errno)
                }
            }
        }
        for city in citys {
            let parameters: Parameters = ["key":UserSetting.newAppkey,
                                          "city":city.cityCN]
            Alamofire.request(UserSetting.newWeatherUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { [weak self] (response) in
                guard self != nil else { return }
                switch response.result {
                case .success:
                    if let value = response.result.value{
                        let json = JSON(value)
                        let choosedCity: ChoosedCity = ChoosedCity.init(city: city.cityCN, weather: getRealWeather(json: json), temperature: json["result"][0]["temperature"].stringValue, wind: json["result"][0]["wind"].stringValue)
                        self?.choosedCities[city.cityCN] = choosedCity
                    }
                case .failure(let errno):
                    HUD.hide()
                    self?.showHub(text: "实时数据获取失败")
                    print(errno)
                }
            }
        }
        
        self.showHub(text: self.searchLocation + "数据更新完毕\n" + "时间:" + getTime(time: self.updateTime))
    }
    
    
    func updateForecastUI(json: JSON) {
        data.remove(at: 0)
        //这里面生成一个随机数，保证每次获得的都不一样
        data.append(self.searchLocation + String(arc4random()))
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    
    func updatePM25UI(json: JSON) {
        // 数字需要校验下，如果没有数据怎么办？例如0 / -1
        // 直接显示未获得吧～
        let pm25: String = self.verifyInteger(num: json["result"][0]["pm25"].intValue)
        let pm10: String = self.verifyInteger(num: json["result"][0]["pm10"].intValue)
        let no2: String = self.verifyInteger(num: json["result"][0]["no2"].intValue)
        let so2: String = self.verifyInteger(num: json["result"][0]["so2"].intValue)
        let aqi: Int = json["result"][0]["aqi"].intValue
        var airConditonString: String = ""
        if pm10.contains(no2) && no2.contains(so2) && no2.contains(so2) && json["result"][0]["quality"].stringValue == "优" {
            airConditonString = "暂无"
        } else {
            airConditonString = json["result"][0]["quality"].stringValue
        }
        
        
        self.pm25.text = String(pm25)
        self.pm10.text = String(pm10)
        self.no2.text = String(no2)
        self.so2.text = String(so2)
        self.aqi.text = String(aqi)
        self.airConditon.text = airConditonString
        
        let distence = CommonTool.pm25ChangeIntoFrame(pm25: aqi)
        self.updateArrow(locationX: (Int(self.view.frame.midX) - 100  - arrowWidth/2 + distence), locationY: self.arrLocationY!)
    }
    
    
    func updateWeatherUI(json: JSON) {
        var weatherLabel: String = ""
        let wind = json["result"][0]["wind"].stringValue
        if wind != "" {
            weatherLabel = json["result"][0]["date"].stringValue + "\n" + getRealWeather(json: json) + json["result"][0]["temperature"].stringValue + "\n" + wind
        } else {
            weatherLabel = json["result"][0]["date"].stringValue + "\n" + getRealWeather(json: json) + json["result"][0]["temperature"].stringValue + "\n" + "未获得风向"
        }
        self.weatherImage.image = UIImage(named:  detectPicture(value: getRealWeather(json: json), weather: UserSetting.WeatherCondition))
        self.weatherLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.weatherLabel.font = UIFont(name: "Helvetica", size: 18)
        self.weatherLabel.text = weatherLabel
    }
    
    
    
    
    func ceateHeader() {
        self.scoreView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
    }
    
    func headerRefresh() {
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
        HUD.show(.progress)
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
        PKHUD.sharedHUD.contentView = CustomPKHUDView(text: text, backgroundColor: UIColor.flatWhiteDark, titleColor:UIColor.flatBlack)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            var locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            locality = getRealCity(city: locality!)
            self.currentLocation = "\(locality!)"
            self.locationImg.isHidden = false
            
            self.userLocationLabel.text = currentLocation
            self.searchLocation = currentLocation
            self.updateWeather(location: self.currentLocation)
        }
    }
    
    func verifyInteger(num: Int) -> String{
        if num <= 0 {
            return "暂无"
        } else {
            return String(num)
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



