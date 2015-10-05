//
//  HomeCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit


class HomeCollectionViewController: BaseDealsViewController {
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var subcategoryLable: UILabel!
    @IBOutlet weak var categoryIconButton: UIButton!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var districtLable: UILabel!
    @IBOutlet weak var sortsLable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityName = "北京"
        requestNewDeals()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cityDidChanged:", name: changeCityNotification, object: nil)
    }
    
    ///城市改变时监听通知的方法
    func cityDidChanged(notification:NSNotification){
        cityName = notification.userInfo![selectedCityName] as? String
        cityLable.text = cityName! + " - 全部"
        districtLable.text = "全部"
        selectRegionName = nil
        requestNewDeals()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: changeCityNotification, object: nil)
    }
    
    override func setupParams(params: NSMutableDictionary) {
        super.setupParams(params)
        params["city"] = cityName ?? "北京"
        if selectCategoryName != nil {
            params["category"] = selectCategoryName!
        }
        if selectRegionName != nil {
            params["region"] = selectRegionName!
        }
        params["sort"] = selectSort?.value ?? 4
    }
    
       
    // MARK: - 控制器的逆向传值
    @IBAction func unwindFromDistrict(segue:UIStoryboardSegue){
        let districtVC = segue.sourceViewController as? DistrictViewController
        districtName = districtVC?.selectedRegionName
        cityLable.text = cityName! + " - " + districtName!
        districtLable.text = districtVC?.selectedSubregionName
        if districtVC?.selectedRegoin?.subregions == nil || districtVC?.selectedSubregionName == "全部" {
            selectRegionName = districtVC?.selectedRegionName
        }else {
            selectRegionName = districtVC?.selectedSubregionName
        }
        if selectRegionName == "全部" {
            selectRegionName = nil
        }

        requestNewDeals()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    @IBAction func unwindFromCategory(segue:UIStoryboardSegue){
        let categoryVC = segue.sourceViewController as? CategoryViewController
        categoryLable.text = categoryVC?.selectedCategoryName
        subcategoryLable.text = categoryVC?.selectedSubCategoryName
        categoryIconButton.setImage(UIImage(named: categoryVC!.selectedIcon!), forState: .Normal)
        categoryIconButton.setImage(UIImage(named: categoryVC!.selectedHHighlightedIcon!), forState: .Highlighted)
        if categoryVC?.subCategories == nil || categoryVC?.selectedSubCategoryName == "全部" {
            selectCategoryName = categoryVC?.selectedCategoryName
        }else {
            selectCategoryName = categoryVC?.selectedSubCategoryName
        }
        if selectCategoryName == "全部分类" {
            selectCategoryName = nil
        }
        
        requestNewDeals()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    @IBAction func unwindFromSorts(segue:UIStoryboardSegue){
        let sortsVc = segue.sourceViewController as? SortsTableViewController
        sortsLable.text = sortsVc?.selectedSort?.label
        currentSelectIndex = sortsVc?.currentSelectIndex
        selectSort = sortsVc?.selectedSort
        requestNewDeals()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "district" {
            let districtVC = segue.destinationViewController as? DistrictViewController
            districtVC?.currentCityName = cityName
        }
        if segue.identifier == "sort" {
            let sortsVc = segue.destinationViewController as? SortsTableViewController
            sortsVc?.currentSelectIndex = currentSelectIndex ?? 3
        }
        if segue.identifier == "search" {
            let searchVC = (segue.destinationViewController as? BaseNavigationController)?.topViewController as? SearchDealsCollectionViewController
            searchVC?.cityName = cityName ?? "北京"
        }
    }
   
}
