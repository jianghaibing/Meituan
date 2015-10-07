//
//  DetailSplitViewController.swift
//  Meituan
//
//  Created by baby on 15/10/6.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DetailSplitViewController: UISplitViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayMode(self.view.bounds.width)
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setDisplayMode(size.width)
    }
    
    func setDisplayMode(width:CGFloat){
        if width == 1024 {
            preferredDisplayMode = .AllVisible
        }else{
            preferredDisplayMode = .PrimaryOverlay
        }
    }
    
    
}
