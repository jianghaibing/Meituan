//
//  Constant.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit


let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

let kScreenWith = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height
let kKeyWindow = UIApplication.sharedApplication().keyWindow

//改变城市的通知常量
let changeCityNotification = "changeCityNotification"
let selectedCityName = "selectedCityName"
