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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTable.dataSource = self
        leftTable.delegate = self
        rightTable.dataSource = self
        rightTable.delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == leftTable {
            let cell = tableView.dequeueReusableCellWithIdentifier("leftCell", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("rightCell", forIndexPath: indexPath)
            return cell
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
