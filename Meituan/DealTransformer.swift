//
//  DealTransformer.swift
//  Meituan
//
//  Created by baby on 15/10/7.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

@objc(DealTransformer)
class DealTransformer: NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass{
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject?{
        return value?.JSONData()
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject?{
        
        return DealsModel(keyValues: value)
    }


}
