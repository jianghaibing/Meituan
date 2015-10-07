//
//  BaseCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit


class BaseCollectionViewController: UICollectionViewController {

    var layout:UICollectionViewFlowLayout!
    lazy var deals:NSMutableArray = NSMutableArray()
    var selectDeal:DealsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layoutInset(collectionView!.bounds.width)
       
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
    
    //MARK:UICollectionDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectDeal = deals[indexPath.item] as? DealsModel
        performSegueWithIdentifier("split", sender: self)
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "split" {
            let splitVC = segue.destinationViewController as! DetailSplitViewController
            let rightVC = splitVC.viewControllers.last as? DetailRightViewController
            let leftVC = (splitVC.viewControllers.first as? BaseNavigationController)?.topViewController as? DetailLeftViewController
            rightVC?.deal = selectDeal
            leftVC?.deal = selectDeal
            
        }
    }
    
    @IBAction func unwindToCollectDeals(segue:UIStoryboardSegue) {
        collectionView!.reloadData()
    }


}
