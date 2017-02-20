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
        //设置代理
        self.searchBar.delegate = self
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView?.rowHeight = UITableViewAutomaticDimension
        self.tabelView?.estimatedRowHeight = 100
        let cellNib = UINib(nibName: cellId, bundle: nil)
        self.tabelView.register(cellNib, forCellReuseIdentifier: cellId)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  !filteredCities.isEmpty || searchBar.text != ""{
            return filteredCities.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city: City
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as?CityListCellTableViewCell
        if searchBar.text != ""{
            cell?.textLabel?.textColor = UIColor.white
            city = filteredCities[indexPath.row]
            cell?.labelOfCity?.text = city.cityCN
            return cell!
        }else{
            city = cities[indexPath.row]
            cell?.addCityName(city)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.dismiss(animated: true, completion: nil);
        
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
