//
//  BaseDealsViewController.swift
//  Meituan
//
//  Created by baby on 15/10/4.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit


class BaseDealsViewController: BaseCollectionViewController,DPRequestDelegate {
    
    lazy var nodataView:UIImageView = UIImageView(image: UIImage(named: "icon_deals_empty"))
    var districtName:String?
    var cityName:String?
    var currentSelectIndex:Int?
    var selectCategoryName:String?
    var selectSort:SortsModel?
    var selectRegionName:String?
    var currentPage:Int = 1
    var lastRequest:DPRequest?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreDeals()
        })
        collectionView!.footer.automaticallyHidden = true
        collectionView!.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestNewDeals()
        })
        collectionView!.header.automaticallyChangeAlpha = true
        //没有数据时的图片
        nodataView.hidden = true
        view.addSubview(nodataView)
        constrain(nodataView) { (nodataView:LayoutProxy) -> () in
            nodataView.center == nodataView.superview!.center
        }

    }

    //MARK: - 数据请求的方法
    func requestDeals(){
        let dpapi = DPAPI()
        let params = NSMutableDictionary()
        setupParams(params)
        lastRequest = dpapi.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
    }
    
    func setupParams(params:NSMutableDictionary){
        params["limit"] = 15
        params["page"] = currentPage
    }
    
    func requestNewDeals(){
        currentPage = 1
        requestDeals()
    }
    
    func requestMoreDeals(){
        currentPage++
        requestDeals()
    }
    
    //MARK: - 请求数据完成的回调
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Text
        hud.labelText = "数据请求错误，请稍后再试"
        hud.hide(true, afterDelay: 2)
        collectionView!.footer.endRefreshing()
        collectionView!.header.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if currentPage > 1 {//如果上拉加载失败，页面减回去
            currentPage--
        }
    }
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        if request != lastRequest{
            return
        }
        if currentPage == 1{
            deals.removeAllObjects()
        }
        let newDeals = DealsModel.objectArrayWithKeyValuesArray(result["deals"])
        deals.addObjectsFromArray(newDeals as [AnyObject])
        collectionView?.reloadData()
        //请求数据完成需要结束刷新
        collectionView!.footer.endRefreshing()
        collectionView!.header.endRefreshing()
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        //没有更多数据时隐藏上拉加载更多控件
        if result["total_count"] as! Int == deals.count {
            collectionView!.footer.hidden = true
        }
        
        //没有数据时显示
        if deals.count == 0 {
            collectionView!.header.hidden = true
            nodataView.hidden = false
        }else{
            collectionView!.header.hidden = false
            nodataView.hidden = true
        }
    }

    
    
}
