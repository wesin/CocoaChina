//
//  DataContent.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import Foundation

struct DataContent {
    var title = ""
    var url = ""
    var time = ""
    var imgurl = ""
    var click = ""
    
    init(contentObj:[String:AnyObject]) {
        self.title = contentObj["title"] as? String ?? ""
        self.url = contentObj["url"] as? String ?? ""
        self.time = contentObj["time"] as? String ?? ""
        self.imgurl = contentObj["imgurl"] as? String ?? ""
        self.click = contentObj["click"] as? String ?? ""
    }
}

