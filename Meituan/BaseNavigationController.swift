//
//  BaseNavigationController.swift
//  Meituan
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBar.setBackgroundImage(UIImage(named: "bg_navigationBar_normal"), forBarMetrics: UIBarMetrics.Default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
