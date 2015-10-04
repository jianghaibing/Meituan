//
//  CenterlineLabel.swift
//  Meituan
//
//  Created by baby on 15/10/3.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CenterlineLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let line = UIBezierPath(rect: CGRectMake(rect.origin.x, rect.size.height/2, rect.size.width, 1))
        line.fill()
    }
    

}
