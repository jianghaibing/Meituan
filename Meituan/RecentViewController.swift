//
//  RecentViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class RecentViewController: BaseCollectionViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "RecentDealsTable")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 50
        if let results = try! managedObjectContext.executeFetchRequest(fetchRequest) as? [RecentDealsTable] {
            let dealsArray = NSMutableArray()
            print(results.count)
            for (index,_) in results.enumerate() {
                let deal = results[index].deal!
                deal.desc = results[index].desc!
                dealsArray.addObject(deal)
            }
            deals = dealsArray
        }
    }
    @IBAction func backButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
