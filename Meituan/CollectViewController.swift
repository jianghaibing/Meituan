//
//  CollectViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CollectViewController: BaseCollectionViewController {

    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var selectAllItem: UIBarButtonItem!
    @IBOutlet weak var deselectAllItem: UIBarButtonItem!
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    @IBOutlet weak var editItem: UIBarButtonItem!
    
    var selectCount = 0
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "CollectDealsTable")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let results = try! managedObjectContext.executeFetchRequest(fetchRequest) as? [CollectDealsTable] {
            let dealsArray = NSMutableArray()
            for result in results {
                let deal = result.deal!
                deal.desc = result.desc!
                dealsArray.addObject(deal)
            }
            deals = dealsArray
        }
        
        if deals.count == 0 {
            editItem.enabled = false
        }
    
        hideItems()
    }
    
    func hideItems(){
        selectAllItem.title = nil
        selectAllItem.enabled = false
        deselectAllItem.title = nil
        deselectAllItem.enabled = false
        deleteItem.title = nil
        deleteItem.enabled = false
    }
    
    func showItems(){
        selectAllItem.title = "  全选  "
        selectAllItem.enabled = true
        deselectAllItem.title = "  全不选  "
        deselectAllItem.enabled = true
        deleteItem.title = "  删除  "
    }

    //MARK: - Item点击事件
    @IBAction func backButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func selectAllClick(sender: UIBarButtonItem) {
        for deal in deals {
            (deal as! DealsModel).checking = true
        }
        selectCount = deals.count
        deleteItem.enabled = true
        deleteItem.title = "  删除（\(selectCount)）  "
        collectionView!.reloadData()
    }

    @IBAction func deselectAllClick(sender: UIBarButtonItem) {
        for deal in deals {
            (deal as! DealsModel).checking = false
        }
        selectCount = 0
        deleteItem.enabled = false
        deleteItem.title = "  删除  "
        collectionView!.reloadData()
    }

    @IBAction func delectItemClick(sender: UIBarButtonItem) {
        
        let tempDeals = NSMutableArray()//用来装被删除的模型
        for deal in deals {
            let deal = deal as! DealsModel
            if deal.checking ?? false {
                let fetchRquest = NSFetchRequest(entityName: "CollectDealsTable")
                fetchRquest.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
                if let results = try! managedObjectContext.executeFetchRequest(fetchRquest) as? [CollectDealsTable] {
                    if results.count > 0 {
                        let findDeal = results[0]
                        managedObjectContext.deleteObject(findDeal)
                    }
                }
                
                tempDeals.addObject(deal)
            }
        }
        
        deals.removeObjectsInArray(tempDeals as [AnyObject])

        deleteItem.enabled = false
        deleteItem.title = "  删除  "
        
        collectionView!.reloadData()
    }
    
    @IBAction func editItemClick(sender: UIBarButtonItem) {
        if sender.title == "编辑" {
            sender.title = "完成"
            showItems()
            for deal in deals {
                (deal as! DealsModel).editing = true
            }
        
        }else{
            sender.title = "编辑"
            hideItems()
            for deal in deals {
                (deal as! DealsModel).editing = false
                (deal as! DealsModel).checking = false
            }
        }
        selectCount = 0
        collectionView!.reloadData()
    }
    
}
