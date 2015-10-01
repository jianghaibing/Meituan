//
//  CityViewController.swift
//  Meituan
//
//  Created by baby on 15/9/15.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cityGroups:NSArray!
    
    lazy var searchResult:SearchResultTableViewController = {
        var searchResult = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("searchResult") as! SearchResultTableViewController
        self.addChildViewController(searchResult)
        self.view.addSubview(searchResult.view)
        return searchResult
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTable.delegate = self
        cityTable.dataSource = self
        cityTable.sectionIndexColor = UIColor.blackColor()
        //点击cover时让searchBar失去焦点
        cover.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: Selector("resignFirstResponder")))
        cityGroups = MetaDataTool().cityGroups
        searchBar.tintColor = UIColor.colorWithRGB(77, green: 193, blue: 151, alpha: 1)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func closeVC(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cityGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cityGroups[section] as! CityGroupsModel).cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath:indexPath)
        let cityGroup = cityGroups[indexPath.section] as! CityGroupsModel
        let city = cityGroup.cities[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cityGroup = cityGroups[section] as! CityGroupsModel
        return cityGroup.title
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return cityGroups.valueForKeyPath("title") as? [String]//用KVC方式取得title数组
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = true
        UIView.animateWithDuration(0.5) { () -> Void in
            self.cover.hidden = false
        }
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield_hl")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = false
        UIView.animateWithDuration(0.5) { () -> Void in
            self.cover.hidden = true
        }
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResult.view.removeFromSuperview()
        searchBar.text = ""
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResult.view.hidden = true
        }else{
            searchResult.view.hidden = false
            searchResult.searchText = searchText
            constrain(searchResult.view,searchBar) { (resultView,search) -> () in
                resultView.left == resultView.superview!.left
                resultView.right == resultView.superview!.right
                resultView.bottom == resultView.superview!.bottom
                resultView.top == search.bottom + 10
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cityGroup = cityGroups[indexPath.section] as! CityGroupsModel
        let cityName = cityGroup.cities[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(changeCityNotification, object: nil, userInfo: [selectedCityName:cityName])
        self.dismissViewControllerAnimated(true, completion: nil)
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
