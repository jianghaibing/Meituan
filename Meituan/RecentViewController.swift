//
//  RecentViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class RecentViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
