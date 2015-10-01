//
//  DistrictViewController.swift
//  Meituan
//
//  Created by baby on 15/9/14.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DistrictViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    var cities:NSMutableArray!
    var currentRegoins:NSMutableArray?
    var selectedRegoin:RegionsModel?
    var selectedSubregoinName:String?
    var selectedRegoinName:String?
    var currentCityName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = MetaDataTool().cities
        let predicate = NSPredicate(format: "name == %@", currentCityName!)
        let city = cities.filteredArrayUsingPredicate(predicate).first as! CityModel
        let currentRegoinArray = city.regions
        currentRegoins = RegionsModel.objectArrayWithKeyValuesArray(currentRegoinArray)//将字典数字转换成模型数组
        
        leftTable.dataSource = self
        leftTable.delegate = self
        rightTable.dataSource = self
        rightTable.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cityDidChanged:", name: changeCityNotification, object: nil)
    }
    
    func cityDidChanged(notification:NSNotification){
        currentCityName = notification.userInfo![selectedCityName] as? String
        let predicate = NSPredicate(format: "name == %@", currentCityName!)
        let city = cities.filteredArrayUsingPredicate(predicate).first as! CityModel
        let currentRegoinArray = city.regions
        currentRegoins = RegionsModel.objectArrayWithKeyValuesArray(currentRegoinArray)
        leftTable.reloadData()
        selectedRegoin = nil
        rightTable.reloadData()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTable{
            return currentRegoins?.count ?? 0
        }else{
            return selectedRegoin?.subregions?.count ?? 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == leftTable {
            let cell = tableView.dequeueReusableCellWithIdentifier("leftCell", forIndexPath: indexPath)
            let currentRegoin = currentRegoins![indexPath.row] as! RegionsModel
            cell.textLabel?.text = currentRegoin.name
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
            if let _ = currentRegoin.subregions {
                cell.accessoryType = .DisclosureIndicator
            }else{
                cell.accessoryType = .None
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("rightCell", forIndexPath: indexPath)
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
            cell.textLabel?.text = selectedRegoin?.subregions![indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == leftTable {
            selectedRegoin = currentRegoins![indexPath.row] as? RegionsModel
            rightTable.reloadData()
            selectedRegoinName = selectedRegoin?.name
            if selectedRegoin?.subregions == nil{
                performSegueWithIdentifier("unwindDistict", sender: self)
            }
        }else{
            selectedSubregoinName = selectedRegoin?.subregions![indexPath.row]
            performSegueWithIdentifier("unwindDistict", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
