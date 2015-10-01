//
//  SearchResultTableViewController.swift
//  Meituan
//
//  Created by baby on 15/9/20.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    var cities:NSMutableArray!
    var results:[CityModel]?
    
    var searchText:String?{
        didSet{
            searchText = searchText?.lowercaseString//谓词只识别小写
            let predicate = NSPredicate(format: "name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText!,searchText!,searchText!)
            results = cities.filteredArrayUsingPredicate(predicate) as? [CityModel]
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cities = MetaDataTool().cities
       
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = results![indexPath.row].name
        return cell
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "共搜到\(results?.count ?? 0)个城市"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cityName = results![indexPath.row].name
        NSNotificationCenter.defaultCenter().postNotificationName(changeCityNotification, object: nil, userInfo: [selectedCityName:cityName])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
