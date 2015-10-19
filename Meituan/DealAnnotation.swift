//
//  DealAnnotation.swift
//  Meituan
//
//  Created by baby on 15/10/18.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit
import MapKit

class DealAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var icon:String?
    
    init(coordinate:CLLocationCoordinate2D,title:String,subtitle:String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return self.title == object?.title
    }
}
