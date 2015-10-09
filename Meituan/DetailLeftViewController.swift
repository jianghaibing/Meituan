//
//  DetailLeftViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DetailLeftViewController: UIViewController,DPRequestDelegate,UMSocialUIDelegate {
    
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
    var indexForCollect:NSNumber = 0
    var indexForRecent:NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestSigleDeal()
        imageView.sd_setImageWithURL(deal.image_url, placeholderImage: UIImage(named: "placeholder_deal"))
        titleLabel.text = deal.title
        descLabel.text = deal.desc
        currentPriceLabel.text = "￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(deal.current_price)
        listPriceLabel.text = "门店价￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(deal.list_price)
        purchaseCountButton.setTitle("已出售\(deal.purchase_count)", forState: .Normal)
        
        //剩余过期时间设置
        let deadlineStr = deal.purchase_deadline
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let deadline = format.dateFromString(deadlineStr)?.dateByAddingTimeInterval(NSTimeInterval(3600*24))//加一天时间
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
                indexForCollect = (results.last?.id)!
            }
        }
        
        //标记已收藏
        fetchRquest.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
        if managedObjectContext.countForFetchRequest(fetchRquest, error: nil) > 0{
            collectButton.selected = true
        }
        

    }
    
    //保存阅读历史
    func saveRecent(){
        //查找数据，如果当前已经阅读历史里面，先删除数据
        let fetchRquestRecent = NSFetchRequest(entityName: "RecentDealsTable")
        fetchRquestRecent.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
        if let results = try! managedObjectContext.executeFetchRequest(fetchRquestRecent) as? [RecentDealsTable] {
            if results.count > 0 {
                let findDeal = results[0]
                managedObjectContext.deleteObject(findDeal)
            }
        }
        
        //将最近浏览写入数据库
        let entity = NSEntityDescription.entityForName("RecentDealsTable", inManagedObjectContext: managedObjectContext)
        let recentDeals = RecentDealsTable(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        recentDeals.deal = deal
        recentDeals.deal_id = deal.deal_id
        recentDeals.desc = deal.desc
        recentDeals.id = NSNumber(integer: indexForRecent.integerValue + 1)
        do {
            try managedObjectContext.save()
        }catch{
            print("无法保存")
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
        hud.hide(true, afterDelay: 2)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
     
    }
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        let dealDict = (result["deals"] as? NSArray)?.firstObject as? NSDictionary
        let dealTemp = DealsModel(keyValues: dealDict)
        deal.restrictions = dealTemp.restrictions
        if deal.restrictions?.is_refundable == 0 {
            refundableButton.selected = true
            expireRefundableButton.selected = true
        }
        
        saveRecent()
    }

    
    //MARK: - 按钮事件
    @IBAction func backButtonClick(sender: UIButton) {
        splitViewController!.preferredDisplayMode = .PrimaryHidden //保证竖屏状态下可用dismiss掉当前控制器
    }

    @IBAction func buyButtonClick(sender: UIButton) {
        
    }

    @IBAction func shareButtonClick(sender: UIButton) {
        
        UMSocialConfig.setSupportedInterfaceOrientations(.Landscape)
        
        UMSocialData.defaultData().urlResource.setResourceType(UMSocialUrlResourceTypeImage, url: String(deal.image_url))
        
        UMSocialSnsService.presentSnsIconSheetView(splitViewController!, appKey: nil, shareText: deal.desc + "\(deal.deal_h5_url)", shareImage: nil, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone], delegate: self)
        
    }
    
    @IBAction func collectButtonClick(sender: UIButton) {
        
        if sender.selected == false {
            let entity = NSEntityDescription.entityForName("CollectDealsTable", inManagedObjectContext: managedObjectContext)
            let collectDeals = CollectDealsTable(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            collectDeals.deal = deal
            collectDeals.deal_id = deal.deal_id
            collectDeals.desc = deal.desc
            collectDeals.id = NSNumber(integer: indexForCollect.integerValue + 1)
            do {
                try managedObjectContext.save()
            }catch{
                print("无法保存")
            }
            let hud = MBProgressHUD.showHUDAddedTo(splitViewController!.view, animated: true)
            hud.mode = .Text
            hud.labelText = "收藏成功"
            hud.hide(true, afterDelay: 1)
            
        }else{
            let fetchRquest = NSFetchRequest(entityName: "CollectDealsTable")
            fetchRquest.predicate = NSPredicate(format: "deal_id == %@", deal.deal_id)
            if let results = try! managedObjectContext.executeFetchRequest(fetchRquest) as? [CollectDealsTable] {
                if results.count > 0 {
                    let findDeal = results[0]
                    managedObjectContext.deleteObject(findDeal)
                    let hud = MBProgressHUD.showHUDAddedTo(splitViewController!.view, animated: true)
                    hud.mode = .Text
                    hud.labelText = "已取消收藏"
                    hud.hide(true, afterDelay: 1)
                }
            }
        }
        sender.selected = !sender.selected
    }
}
