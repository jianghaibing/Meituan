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

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = CategoryModel.objectArrayWithFilename("categories.plist")
        tableOne.delegate = self
        tableOne.dataSource = self
        
        tableTwo.delegate = self
        tableTwo.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableOne {
            return (categories?.count)!
        }else{
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tableOne{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            cell.textLabel?.text = categories![indexPath.row].name
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
            cell.textLabel?.text = "\(indexPath.row)"
            return cell
        }
    }
    
}
