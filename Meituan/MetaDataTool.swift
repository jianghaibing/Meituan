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
    
    class func categoryWithDeal(deal:DealsModel) -> CategoryModel?{
        let categoriesModel = MetaDataTool().categories
        guard let categoryName = deal.categories.firstObject else{return nil}
        for categoryModel in categoriesModel {
            let categoryModel = categoryModel as! CategoryModel
            if categoryModel.name == categoryName as! String {return categoryModel}
            if let a = categoryModel.subcategories  {
            if a.contains(categoryName as! String){return categoryModel}
            }
        }
        return nil
    }
    
    lazy var cityGroups:NSMutableArray = {
        var cityGroups = CityGroupsModel.objectArrayWithFilename("cityGroups.plist")
        return cityGroups
    }()
    
    lazy var sorts:NSMutableArray = {
        var sorts = SortsModel.objectArrayWithFilename("sorts.plist")
        return sorts
    }()

}
