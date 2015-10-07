//
//  CollectViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CollectViewController: BaseCollectionViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "CollectDealsTable")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let results = try! managedObjectContext.executeFetchRequest(fetchRequest) as? [CollectDealsTable] {
            let dealsArray = NSMutableArray()
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
