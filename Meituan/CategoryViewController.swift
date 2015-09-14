//
//  CategoryViewController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var categories:NSMutableArray?
    @IBOutlet weak var tableOne: UITableView!
    @IBOutlet weak var tableTwo: UITableView!
    var selectedCategory:CategoryModel?
    private var subCategories:[String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = CategoryModel.objectArrayWithFilename("categories.plist")
        tableOne.delegate = self
        tableOne.dataSource = self
        
        tableTwo.delegate = self
        tableTwo.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableOne {
            return (categories?.count)!
        }else{
            if subCategories != nil {
                return subCategories!.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableOne{
            let category = categories![indexPath.row] as! CategoryModel
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            cell.textLabel?.text = category.name
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.imageView?.image = UIImage(named: (category.small_icon)!)
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
        }
    }
    
}
