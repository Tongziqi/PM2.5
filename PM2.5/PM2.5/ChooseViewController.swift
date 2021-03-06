//
//  ChooseViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/15.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit
import ChameleonFramework

class ChooseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    let cellId = "CityListCellTableViewCell"
    var locationCity: String? = nil
    var hideCell = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelView: UITableView!
    
    // 闭包传值
    typealias InputClosureType = (String) -> Void // 定义一个闭包类型（typealias：特定的函数类型函数类型）
    var backClosure: InputClosureType? // 接收上个页面穿过来的闭包块
    func setBackMyClosure(tempClosure: @escaping InputClosureType) {
        self.backClosure = tempClosure
    }
    
    var cities = [City]()
    var choosedCities:[String: ChoosedCity] = [:]
    var filteredCities = [City]()
    var parserCities = [City]()
    var parserXML: ParserXML!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择城市"
        
        // 设定半透明
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.flatBlack
        // 添加做后退和编辑
        self.addBack()
        self.addEdit()
        
        cities = CommonTool.loadData(cities: &cities)
        self.tabelView.separatorStyle = .none
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.flatWhite.cgColor
        self.searchBar.barTintColor = UIColor.flatWhite
        //设置代理
        self.searchBar.delegate = self
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView?.rowHeight = UITableViewAutomaticDimension
        self.tabelView?.estimatedRowHeight = 100
        let cellNib = UINib(nibName: cellId, bundle: nil)
        self.tabelView.register(cellNib, forCellReuseIdentifier: cellId)
        self.tabelView.register(UINib(nibName: "ChooseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseCellTableViewCell")
        
    }
    
    func leftpushTo() {
        let _ =  self.dismiss(animated: true, completion: nil)
    }
    
    func addBack() {
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(UIImage(named: "back"), for: UIControlState())
        backBtn.setImage(UIImage(named: "backpress"), for:  .highlighted)
        backBtn.addTarget(self, action: #selector(self.leftpushTo), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backBtn.frame = CGRect(x: 0, y: 0, width: 10, height: 18)
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: backBtn)
    }
    
    func addEdit() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editCity))
        
    }
    
    
    func editCity() {
        let btn = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editCity))
        let btn2 = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editCity))
        if self.navigationItem.rightBarButtonItem?.title == "完成" {
            self.navigationItem.rightBarButtonItem = btn
            self.tabelView.isEditing = false
            self.tabelView.reloadData()
        } else if !self.hideCell{
            self.navigationItem.rightBarButtonItem = btn2
            self.tabelView.isEditing = true
            self.tabelView.reloadData()
            CommonTool.saveCity(cities: cities)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        parserXML = nil
        filteredCities = []
        searchBar.delegate = nil
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.hideCell || self.locationCity == "获取地理位置失败" {
                return 0
            } else {
                return 1
            }
        case 1:
            if self.hideCell {
                return 0
            } else {
                return cities.count
            }
            
        case 2:
            return filteredCities.count
        default:
            return 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if self.hideCell {
                return 0
            }else {
                return 15
            }
        case 1:
            if self.hideCell {
                return 0
            }else {
                return 15
            }
        case 2:
            return 0.001
        default:
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "当前城市:"
        case 1:
            return "搜索历史:"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        headerView.textLabel?.textAlignment = .left
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && !self.hideCell {
            var cellZero = tableView.cellForRow(at: indexPath) as? CityListCellTableViewCell
            if cellZero == nil {
                cellZero = Bundle.main.loadNibNamed(cellId, owner: self, options: nil)?.last as? CityListCellTableViewCell
            }
            if self.locationCity != "获取地理位置失败" {
                cellZero?.labelOfCity.text = locationCity ?? ""
                cellZero?.locatedLabel.textColor = UIColor.flatRed
                
                let name = self.choosedCities[self.locationCity!]?.weather
                cellZero?.cityLocationimage.image = UIImage(named: "choose" + detectPicture(value: name!, weather: UserSetting.chooseWeatherCondition))
                cellZero?.locatedLabel.text = "当前城市"
                if self.choosedCities[self.locationCity!]?.wind != "" {
                    cellZero?.windLabel.text = self.choosedCities[self.locationCity!]?.wind
                }
                
                cellZero?.temperatureLabel.text = self.choosedCities[self.locationCity!]?.temperature
                
            } else {
                cellZero?.isHidden = true
            }
            return cellZero!
        } else if indexPath.section == 1 && !self.hideCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CityListCellTableViewCell
            cell?.initdata()
            cell?.locatedLabel.text = "已经定位"
            cell?.labelOfCity?.text = cities[indexPath.row].cityCN.components(separatedBy: "/").first!
            if self.choosedCities != [:] {
                let name: String = (self.choosedCities[cities[indexPath.row].cityCN]?.weather) ?? ""
                cell?.cityLocationimage.image = UIImage(named: ("choose" + detectPicture(value: name, weather: UserSetting.chooseWeatherCondition)))
                
            }
            if self.choosedCities[cities[indexPath.row].cityCN]?.wind != "" {
                cell?.windLabel.text = self.choosedCities[cities[indexPath.row].cityCN]?.wind
            }
            cell?.temperatureLabel.text = self.choosedCities[cities[indexPath.row].cityCN]?.temperature
            
            if self.tabelView.isEditing {
                cell?.locatedLabel.text = ""
            }
            return cell!
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCellTableViewCell", for: indexPath) as? ChooseCellTableViewCell
            cell?.initdata()
            let city: City
            if searchBar.text != "" {
                city = filteredCities[indexPath.row]
                cell?.labelOfCity?.text = city.cityCN.components(separatedBy: "/").first
                cell?.locatedLabel.text = "点击查询该城市"
                cell?.locatedLabel.textColor = UIColor.flatOrange
                return cell!
            } else {
                city = cities[indexPath.row]
                cell?.addCityName(city)
                cell?.locatedLabel.text = "点击查询该城市"
                return cell!
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: false)
            if self.backClosure != nil {
                self.backClosure!(locationCity!)
            }
            CommonTool.saveCity(cities: cities)
            self.dismiss(animated: true, completion: nil)
            
        } else if indexPath.section == 1 {
            let city: City
            if !filteredCities.isEmpty{
                city = filteredCities[indexPath.row]
            }else{
                city = cities[indexPath.row]
            }
            searchBar.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: false)
            
            if self.backClosure != nil {
                let tempString: String? = city.cityCN.components(separatedBy: "/").first
                if tempString != nil {
                    self.backClosure!(tempString!)
                }
            }
            CommonTool.saveCity(cities: cities)
            self.dismiss(animated: true, completion: nil);
        }  else if indexPath.section == 2 {
            let city: City
            if !filteredCities.isEmpty{
                city = filteredCities[indexPath.row]
            }else{
                city = cities[indexPath.row]
            }
            searchBar.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: false)
            
            if self.backClosure != nil {
                let tempString: String? = city.cityCN.components(separatedBy: "/").first
                if tempString != nil {
                    self.backClosure!(tempString!)
                }
            }
            var weatherExist = false
            for exitCity in cities {
                if exitCity.cityCN == city.cityCN {
                    weatherExist = true
                    break
                }
            }
            if !weatherExist {
                cities.append(city)
            }
            CommonTool.saveCity(cities: cities)
            self.dismiss(animated: true, completion: nil);
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            if searchBar.text != "" {
                return false
            }else {
                return true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        cities.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        CommonTool.saveCity(cities: cities)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterControllerForSearchText(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if parserCities.isEmpty{
            parserXML = ParserXML()
            parserCities = parserXML.cities
        }
        
        filterControllerForSearchText(searchText)
    }
    
    
    
    func filterControllerForSearchText(_ searchText: String, scope: String = "ALL"){
        if searchText == "" {
            self.hideCell = false
        } else {
            self.hideCell = true
        }
        let btn = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editCity))
        self.navigationItem.rightBarButtonItem = btn
        // 点击了搜索栏就不能编辑了
        self.tabelView.isEditing = false
        filteredCities = parserCities.filter({ (city) -> Bool in
            return city.cityCN.lowercased().contains(searchText.lowercased())
        })
        tabelView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
