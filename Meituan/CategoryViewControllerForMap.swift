//
//  CategoryViewController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CategoryViewControllerForMap: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var categories:NSMutableArray?
    @IBOutlet weak var tableOne: UITableView!
    @IBOutlet weak var tableTwo: UITableView!
    var selectedCategory:CategoryModel?
    var subCategories:[String]?
    var selectedCategoryName:String?
    var selectedSubCategoryName:String?
    var selectedIcon:String?
    var selectedHHighlightedIcon:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = MetaDataTool().categories
        tableOne.delegate = self
        tableOne.dataSource = self
        
        tableTwo.delegate = self
        tableTwo.dataSource = self
        
        selectedSubCategoryName = "全部"

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableOne {
            return categories?.count ?? 0
        }else{
            return subCategories?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableOne{
            let category = categories![indexPath.row] as! CategoryModel
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            cell.textLabel?.text = category.name
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.imageView?.image = UIImage(named: (category.small_icon)!)
            cell.imageView?.highlightedImage = UIImage(named: category.small_highlighted_icon)
            cell.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
            if let _ = category.subcategories {
                cell.accessoryType = .DisclosureIndicator
            }else{
                cell.accessoryType = .None
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_rightpart"))
            cell.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_right_selected"))
            cell.textLabel?.text = subCategories![indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableOne{
            selectedCategory = categories![indexPath.row] as? CategoryModel
            subCategories = selectedCategory?.subcategories
            tableTwo.reloadData()
            selectedCategoryName = selectedCategory?.name
            selectedIcon = selectedCategory?.icon
            selectedHHighlightedIcon = selectedCategory?.highlighted_icon
            if subCategories == nil {
                performSegueWithIdentifier("unwindFromCategoryForMap", sender: self)
            }
            
        }else{
            subCategories = selectedCategory?.subcategories
            selectedSubCategoryName = subCategories![indexPath.row]
            performSegueWithIdentifier("unwindFromCategoryForMap", sender: self)
        }
    }
    
}
