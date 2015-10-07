//
//  DealsModel.swift
//  Meituan
//
//  Created by baby on 15/10/2.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DealsModel: NSObject {
    
    var deal_id:String!
    var title:String!
    var desc:String!
    var list_price:NSNumber!
    var current_price:NSNumber!
    var purchase_count:NSNumber!
    var image_url:NSURL!
    var s_image_url:NSURL!
    var publish_date:String!
    var purchase_deadline:String!
    var deal_h5_url:NSURL!
    var restrictions:RestrictionsModel?
    
    //是否进入编辑状态
    var editing:Bool?
    //是否选中
    var checking:Bool?
    
    override static func replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["desc":"description"]
    }
    
}
