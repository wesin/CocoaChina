//
//  Favorite.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/18.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import Foundation
import CoreData

@objc(Favorite)
class Favorite: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var date: NSDate

}
