//
//  CityModel.swift
//  Meituan
//
//  Created by baby on 15/9/15.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class CityModel: NSObject {
    
    var name:String!
    var pinYin:String!
    var pinYinHead:String!
    var regions:NSArray!
    
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["regions" : RegionsModel()]
    }

}
