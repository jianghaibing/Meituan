//
//  SortsTableViewController.swift
//  Meituan
//
//  Created by baby on 15/10/1.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class SortsTableViewController: UITableViewController {
    
    var sorts:NSMutableArray?
    var selectedSort:SortsModel?
    var currentSelectIndex:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sorts = MetaDataTool().sorts
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sorts?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let sort = sorts![indexPath.row] as! SortsModel
        let sortButton = cell.viewWithTag(99) as! SortButton
        if indexPath.row == currentSelectIndex ?? 0{
            sortButton.selected = true
        }
        sortButton.selectedSort = sort
        sortButton.setTitle(sort.label, forState: .Normal)
        sortButton.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    
    func buttonClick(sender:SortButton){
        selectedSort = sender.selectedSort
        sender.selected = true
        currentSelectIndex = selectedSort!.value.integerValue - 1
        performSegueWithIdentifier("unwindFromSorts", sender: self)
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
