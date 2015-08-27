//
//  JSONExtension.swift
//  CocoaChina
//
//  Created by 何文新 on 15/8/27.
//  Copyright © 2015年 Hupun. All rights reserved.
//

import Foundation

//MARK:SwiftyJson 扩展--
extension JSON {
    
    public init(jsonStr:String, dataEncoding:UInt = NSUTF8StringEncoding) {
        if let data = NSString(string: jsonStr).dataUsingEncoding(dataEncoding) {
            if let object:AnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments){
                self.init(object)
            } else {
                self.init(NSNull())
            }
        } else {
            self.init(NSNull())
        }
    }
}