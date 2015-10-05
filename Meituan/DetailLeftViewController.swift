//
//  DetailLeftViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DetailLeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonClick(sender: UIButton) {
        splitViewController!.preferredDisplayMode = .PrimaryHidden
        splitViewController!.dismissViewControllerAnimated(true, completion: nil)
    }


}
