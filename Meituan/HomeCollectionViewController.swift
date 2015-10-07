//
//  HomeCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit


class HomeCollectionViewController: BaseDealsViewController,AwesomeMenuDelegate {
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
        setupAwesomeMenu()
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
    
    //MARK: - awesomeMenu
    func setupAwesomeMenu(){
        let startItem = AwesomeMenuItem(image: UIImage(named: "icon_pathMenu_background_normal"), highlightedImage: UIImage(named: "icon_pathMenu_background_highlighted"), contentImage: UIImage(named: "icon_pathMenu_mainMine_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_mainMine_highlighted"))
        let item1 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_mine_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_mine_highlighted"))
        let item2 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        let item3 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_scan_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_scan_highlighted"))
        let item4 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_more_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_more_highlighted"))
        let menuItems = [item1,item2,item3,item4]
        let menu = AwesomeMenu(frame: CGRectZero, startItem: startItem, menuItems: menuItems)
        menu.alpha = 0.5
        menu.rotateAddButton = false
        menu.startPoint = CGPointMake(50, 150)
        menu.menuWholeAngle = CGFloat(M_PI_2)
        menu.delegate = self
        self.view.addSubview(menu)
        constrain(menu) { (menu:LayoutProxy) -> () in
            menu.leading == menu.superview!.leading
            menu.bottom == menu.superview!.bottom
            menu.width == 200
            menu.height == 200
        }
    }
    
    
    func awesomeMenuDidFinishAnimationOpen(menu: AwesomeMenu!) {
        UIView.animateWithDuration(0.3) { () -> Void in
            menu.alpha = 1
            menu.contentImage = UIImage(named: "icon_pathMenu_cross_normal")
        }
    }
    
    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        UIView.animateWithDuration(0.3) { () -> Void in
            menu.alpha = 0.5
            menu.contentImage = UIImage(named: "icon_pathMenu_mainMine_normal")
        }
    }
    
    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        UIView.animateWithDuration(0.3) { () -> Void in
            menu.alpha = 0.5
            menu.contentImage = UIImage(named: "icon_pathMenu_mainMine_normal")
        }
        switch idx {
        case 0:
            print(idx)
        case 1:
            performSegueWithIdentifier("collect", sender: self)
        case 2:
            performSegueWithIdentifier("recent", sender: self)
        case 3:
            print(idx)
        default:
            print("默认")
        }
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
        super.prepareForSegue(segue, sender: sender)
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
