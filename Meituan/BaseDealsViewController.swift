//
//  BaseDealsViewController.swift
//  Meituan
//
//  Created by baby on 15/10/4.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit


class BaseDealsViewController: UICollectionViewController,DPRequestDelegate {
    
    lazy var deals:NSMutableArray = NSMutableArray()
    lazy var nodataView:UIImageView = UIImageView(image: UIImage(named: "icon_deals_empty"))
    var districtName:String?
    var cityName:String?
    var currentSelectIndex:Int?
    var selectCategoryName:String?
    var selectSort:SortsModel?
    var selectRegionName:String?
    var currentPage:Int = 1
    var lastRequest:DPRequest?
    
    var layout:UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layoutInset(collectionView!.bounds.width)
        
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

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        layoutInset(size.width)
    }
    
    ///根据屏幕宽度设置布局
    private func layoutInset(width:CGFloat){
        var cols = 2
        if width == 1024 {
            cols = 3
        }
        let inset = (width - layout.itemSize.width * CGFloat(cols)) / CGFloat(cols + 1)
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        layout.minimumLineSpacing = inset
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
        performSelector("hideHud", withObject: self, afterDelay: 2)
        collectionView!.footer.endRefreshing()
        collectionView!.header.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if currentPage > 1 {//如果上拉加载失败，页面减回去
            currentPage--
        }
    }
    
    func hideHud(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
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

    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DealCell
        let deal = deals[indexPath.item] as! DealsModel
        cell.deal = deal
        return cell
    }
    
    
}
