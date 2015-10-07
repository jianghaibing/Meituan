//
//  StringFormatTool.swift
//  Meituan
//
//  Created by baby on 15/10/7.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class NumberFormatStringTool: NSObject {

    ///如果大于2位小数保留2位小数，其余都等于本身
    class func leaveNumberToTwoDecimal(number:NSNumber) -> String{
        if let dotLocation = number.stringValue.rangeOfString(".")?.last,let length = number.stringValue.rangeOfString(number.stringValue)?.last{
            if Int(String(length))! - Int(String(dotLocation))! > 2 {
                let stringValue = String(format: "%.2f", number.floatValue)
                return stringValue
            }else{
                return number.stringValue
            }
        }else{
            return number.stringValue
        }
    }

}
