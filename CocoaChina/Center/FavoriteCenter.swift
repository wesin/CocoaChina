//
//  FavoriteCenter.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/18.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import Foundation
import CoreData

class FavoriteCenter: NSObject {
    
    private override init() {
        let modelPath: NSString = NSBundle.mainBundle().pathForResource("CocoaChina", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath as String))!
        
        let stack:SugarRecordStackProtocol = DefaultCDStack(databaseName: "cocoa.sqlite", model: model, automigrating: true)
        (stack as! DefaultCDStack).autoSaving = true
        SugarRecord.addStack(stack)
    }
    
    private static let a = FavoriteCenter()
    
    static var instance : FavoriteCenter {
        return a
    }
    
    /**
    初始化
    
    - returns: 
    */
    func initCenter() {
        
    }
    
    func getFavoriteList() -> SugarRecordResults {
        return Favorite.all().sorted(by: "date", ascending: true).find()
    }
    
    func deleteFavoriteByIndex(index:Int) {
        let list = getFavoriteList()
        let item = list[index] as! Favorite
        item.beginWriting().delete().endWriting()
    }
    
}
