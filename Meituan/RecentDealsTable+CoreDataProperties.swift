//
//  RecentDealsTable+CoreDataProperties.swift
//  Meituan
//
//  Created by baby on 15/10/6.
//  Copyright © 2015年 baby. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RecentDealsTable {

    @NSManaged var id: NSNumber?
    @NSManaged var deal: DealsModel?
    @NSManaged var deal_id: String?

}
