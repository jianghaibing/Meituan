//
//  HomeCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var subcategoryLable: UILabel!
    @IBOutlet weak var categoryIconButton: UIButton!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var districtLable: UILabel!
    @IBOutlet weak var sortsLable: UILabel!
    var districtName:String?
    var cityName:String?
    var currentSelectIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName = "北京"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cityDidChanged:", name: changeCityNotification, object: nil)
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func cityDidChanged(notification:NSNotification){
        cityName = notification.userInfo![selectedCityName] as? String
        cityLable.text = cityName! + " - 全部"
        districtLable.text = "全部"
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: changeCityNotification, object: nil)
    }

    
    // MARK: - Navigation

    @IBAction func unwindFromDistrict(segue:UIStoryboardSegue){
        let districtVC = segue.sourceViewController as? DistrictViewController
        districtName = districtVC?.selectedRegoinName
        cityLable.text = cityName! + " - " + districtName!
        districtLable.text = districtVC?.selectedSubregoinName
    }
    
    @IBAction func unwindFromCategory(segue:UIStoryboardSegue){
        let categoryVC = segue.sourceViewController as? CategoryViewController
        categoryLable.text = categoryVC?.selectedCategoryName
        subcategoryLable.text = categoryVC?.selectedSubCategoryName
        categoryIconButton.setImage(UIImage(named: categoryVC!.selectedIcon!), forState: .Normal)
        categoryIconButton.setImage(UIImage(named: categoryVC!.selectedHHighlightedIcon!), forState: .Highlighted)
        
    }
    
    @IBAction func unwindFromSorts(segue:UIStoryboardSegue){
        let sortsVc = segue.sourceViewController as? SortsTableViewController
        sortsLable.text = sortsVc?.selectedSort?.label
        currentSelectIndex = sortsVc?.currentSelectIndex
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
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
