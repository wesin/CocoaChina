//
//  NSDateExtension.swift
//  CocoaChina
//
//  Created by 何文新 on 15/8/27.
//  Copyright © 2015年 Hupun. All rights reserved.
//

import Foundation

extension NSDate {
    public static func dateFromInterval(timeInterval:Int) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(timeInterval / 1000))
    }
}