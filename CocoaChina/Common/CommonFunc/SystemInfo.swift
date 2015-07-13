//
//  SystemInfo.swift
//  HupunErp
//
//  Created by 何文新 on 15/4/20.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit
//import "sys/utsname.h"

class SystemInfo {
    
    static func getVersion() -> String {
        let infoDic = NSBundle.mainBundle().infoDictionary!
        return infoDic["CFBundleShortVersionString"]! as! String
    }
    
    static func getIosVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    static func isIos8() -> Bool {
        return SystemInfo.getIosVersion() >= "8.0"
    }
    
    static func getPhoneMode() -> String {
        let model = OCCommonFunc.getMachineVersion()
        println(model)
        return model
//        return UIDevice.currentDevice().model
    }
    
    static func getUniqueID() -> String {
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    
    static func getSystemInfo() -> [String:String] {
        var infoDic = [String:String]()
        infoDic["appversion"] = getVersion()
        infoDic["device"] = getUniqueID()
        infoDic["model"] = getPhoneMode()
        infoDic["type"] =  "IOS"
        infoDic["version"] = getIosVersion()
        return infoDic
    }
    
}
