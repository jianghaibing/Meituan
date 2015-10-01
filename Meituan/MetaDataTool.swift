//
//  MetaDataTool.swift
//  Meituan
//
//  Created by baby on 15/9/26.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class MetaDataTool: NSObject {
    
    lazy var cities:NSMutableArray = {
        var cities = CityModel.objectArrayWithFilename("cities.plist")
        return cities
    }()
    
    lazy var categories:NSMutableArray = {
        var categories = CategoryModel.objectArrayWithFilename("categories.plist")
        return categories
    }()
    
    lazy var cityGroups:NSMutableArray = {
        var cityGroups = CityGroupsModel.objectArrayWithFilename("cityGroups.plist")
        return cityGroups
    }()
    
    lazy var sorts:NSMutableArray = {
        var sorts = SortsModel.objectArrayWithFilename("sorts.plist")
        return sorts
    }()

}
