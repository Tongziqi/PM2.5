//
//  ChooseViewController.swift
//  PM2.5
//
//  Created by 童小托 on 2017/2/15.
//  Copyright © 2017年 童小托. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    let cellId = "CityListCellTableViewCell"
    var locationCity: String? = nil
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // 闭包传值
    typealias InputClosureType = (String) -> Void // 定义一个闭包类型（typealias：特定的函数类型函数类型）
    var backClosure: InputClosureType? // 接收上个页面穿过来的闭包块
    func setBackMyClosure(tempClosure: @escaping InputClosureType) {
        self.backClosure = tempClosure
    }
    
    var cities = [City]()
    var filteredCities = [City]()
    var parserCities = [City]()
    var parserXML: ParserXML!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.tabelView.separatorStyle = .none
        //设置代理
        self.searchBar.delegate = self
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView?.rowHeight = UITableViewAutomaticDimension
        self.tabelView?.estimatedRowHeight = 100
        let cellNib = UINib(nibName: cellId, bundle: nil)
        self.tabelView.register(cellNib, forCellReuseIdentifier: cellId)
        
        print(cities)
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
            return 1
        case 1:
            return cities.count
        case 2:
            return filteredCities.count
        default:
            return 1
        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.001
        case 1:
            return 10
        case 2:
            if filteredCities.count == 0 {
                return 0.001
            } else {
                return 10
            }
        default:
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CityListCellTableViewCell
            cell?.labelOfCity.text = locationCity ?? ""
            cell?.locatedLabel.isHidden = true
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CityListCellTableViewCell
            cell?.locationImg.isHidden = true
            cell?.labelOfCity?.text = cities[indexPath.row].cityCN
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        } else if indexPath.section == 2 {
            let city: City
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CityListCellTableViewCell
            if searchBar.text != "" {
                cell?.textLabel?.textColor = UIColor.white
                city = filteredCities[indexPath.row]
                cell?.labelOfCity?.text = city.cityCN
                cell?.locationImg.isHidden = true
                cell?.locatedLabel.text = "点击查询该城市"
                cell?.locatedLabel.textColor = UIColor.green
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                return cell!
            } else {
                city = cities[indexPath.row]
                cell?.addCityName(city)
                cell?.locationImg.isHidden = true
                cell?.locatedLabel.text = "点击查询该城市"
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                return cell!
            }
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            if self.backClosure != nil {
                self.backClosure!(locationCity!)
            }
            self.dismiss(animated: true, completion: nil)
        } else if indexPath.section == 1 {
            let city: City
            if !filteredCities.isEmpty{
                city = filteredCities[indexPath.row]
            }else{
                city = cities[indexPath.row]
            }
            searchBar.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: true)
            
            if self.backClosure != nil {
                let tempString: String? = city.cityCN
                if tempString != nil {
                    self.backClosure!(tempString!)
                }
            }
            cities.append(city)
            self.saveCity()
            self.dismiss(animated: true, completion: nil);
        }  else if indexPath.section == 2 {
            let city: City
            if !filteredCities.isEmpty{
                city = filteredCities[indexPath.row]
            }else{
                city = cities[indexPath.row]
            }
            searchBar.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: true)
            
            if self.backClosure != nil {
                let tempString: String? = city.cityCN
                if tempString != nil {
                    self.backClosure!(tempString!)
                }
            }
            cities.append(city)
            self.saveCity()
            self.dismiss(animated: true, completion: nil);
        }
        
    }
    
    fileprivate func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    fileprivate func dataFilePath() -> String{
        return (documentsDirectory() as NSString).appendingPathComponent("Cities.plist")
    }
    
    func saveCity(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(cities, forKey: "Cities")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadData(){
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                cities = unarchiver.decodeObject(forKey: "Cities") as! [City]
                unarchiver.finishDecoding()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchBar.text != ""{
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        cities.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
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
        filteredCities = parserCities.filter({ (city) -> Bool in
            return city.cityCN.lowercased().contains(searchText.lowercased())
        })
        tabelView.reloadData()
    }
}
