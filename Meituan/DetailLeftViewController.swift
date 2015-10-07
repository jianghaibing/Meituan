//
//  DetailLeftViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DetailLeftViewController: UIViewController,DPRequestDelegate {
    
    var deal:DealsModel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var listPriceLabel: CenterlineLabel!
    @IBOutlet weak var purchaseCountButton: UIButton!
    @IBOutlet weak var refundableButton: UIButton!
    @IBOutlet weak var expireRefundableButton: UIButton!
    @IBOutlet weak var expireDateButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    var index:NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestSigleDeal()
        imageView.sd_setImageWithURL(deal.image_url, placeholderImage: UIImage(named: "placeholder_deal"))
        titleLabel.text = deal.title
        descLabel.text = deal.desc
        currentPriceLabel.text = "￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(deal.current_price)
        listPriceLabel.text = "门店价￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(deal.list_price)
        purchaseCountButton.setTitle("已出售\(deal.purchase_count)", forState: .Normal)
        
        let deadlineStr = deal.purchase_deadline
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let deadline = format.dateFromString(deadlineStr)?.dateByAddingTimeInterval(NSTimeInterval(3600*24))
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags = NSCalendarUnit(rawValue: NSCalendarUnit.Day.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue)
        let compnents = calendar.components(unitFlags, fromDate: now, toDate: deadline!, options: NSCalendarOptions.init(rawValue: 0))
        if compnents.day > 365 {
            expireDateButton.setTitle("过期时间超过一年", forState: .Normal)
        }else{
            expireDateButton.setTitle("剩余\(compnents.day)天\(compnents.hour)小时\(compnents.minute)分钟", forState: .Normal)
        }

        //取得最后一个团购在数据库中的ID
        let fetchRquest = NSFetchRequest(entityName: "CollectDealsTable")
        if let results = try! managedObjectContext.executeFetchRequest(fetchRquest) as? [CollectDealsTable] {
            if results.count > 0{
                index = (results.last?.id)!
            }
        }
        
        //标记已收藏
        fetchRquest.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
        if managedObjectContext.countForFetchRequest(fetchRquest, error: nil) > 0{
            collectButton.selected = true
        }

    }
    
    //MARK: - 数据请求的方法
    func requestSigleDeal(){
        let dpapi = DPAPI()
        let params = NSMutableDictionary()
        params["deal_id"] = deal.deal_id
        dpapi.requestWithURL("v1/deal/get_single_deal", params: params, delegate: self)
    }
    
    //MARK: - 请求数据完成的回调
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Text
        hud.labelText = "数据请求错误，请稍后再试"
        performSelector("hideHud", withObject: self, afterDelay: 2)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
     
    }
    
    func hideHud(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        let dealDict = (result["deals"] as? NSArray)?.firstObject as? NSDictionary
        let dealTemp = DealsModel(keyValues: dealDict)
        deal.restrictions = dealTemp.restrictions
        if deal.restrictions?.is_refundable == 0 {
            refundableButton.selected = true
            expireRefundableButton.selected = true
        }
    }

    
    //MARK: - 按钮事件
    @IBAction func backButtonClick(sender: UIButton) {
        splitViewController!.preferredDisplayMode = .PrimaryHidden //保证竖屏状态下可用dismiss掉当前控制器
    }

    @IBAction func buyButtonClick(sender: UIButton) {
        
    }

    @IBAction func shareButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func collectButtonClick(sender: UIButton) {
        
        if sender.selected == false {
            let entity = NSEntityDescription.entityForName("CollectDealsTable", inManagedObjectContext: managedObjectContext)
            let collectDeals = CollectDealsTable(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            collectDeals.deal = deal
            collectDeals.deal_id = deal.deal_id
            collectDeals.desc = deal.desc
            collectDeals.id = NSNumber(integer: index.integerValue + 1)
            do {
                try managedObjectContext.save()
            }catch{
                print("无法保存")
            }
        }else{
            let fetchRquest = NSFetchRequest(entityName: "CollectDealsTable")
            fetchRquest.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
            if let results = try! managedObjectContext.executeFetchRequest(fetchRquest) as? [CollectDealsTable] {
                if results.count > 0 {
                    let findDeal = results[0]
                    managedObjectContext.deleteObject(findDeal)
                }
            }
        }
        sender.selected = !sender.selected
    }
}
