//
//  CommonFunc.swift
//  SwiftEasyStock
//
//  Created by 何文新 on 15/2/21.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit


var bgView:UIView?                          //显示过滤页面时出现的一个黑色遮盖页面

class CommonFunc {
    
    //MARK:ViewInStory
    static func getViewFromStoryBoard(boardName:String, viewIndetifier:String) -> AnyObject? {
        let storyBoard = UIStoryboard(name: boardName, bundle: nil)
        return storyBoard.instantiateViewControllerWithIdentifier(viewIndetifier)
    }
    
    
    static func showBgView(parentView:UIView)  {
        if bgView == nil {
            bgView = UIView()
            bgView?.backgroundColor = UIColor.blackColor()
            bgView?.alpha = 0.8
            
        }
        bgView?.frame = parentView.bounds
        parentView.addSubview(bgView!)
    }
    
    static func removeBgView() {
        bgView?.removeFromSuperview()
    }
    
    static func getUIColorFromHexStr(hexStr:String) -> UIColor {
        let red = CGFloat(hex2dec(hexStr[0..<2]))
        let green = CGFloat(hex2dec(hexStr[2..<4]))
        let blue = CGFloat(hex2dec(hexStr.substringFromIndex(4)))
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    
    //十六进制转十进制
    static func hex2dec(num:String) -> Int {
        let str = num.uppercaseString
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    //MARK:Array Search
    static func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
        for (index, value) in enumerate(array) {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    static func screenshotFromView(view:UIView) -> UIImage {
        let width = view.frame.size.width
        let height = view.frame.size.height
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK:ImageSize auto resize
    static func fitSmallImage(image:UIImage, boundSize:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(boundSize)
        let rect = CGRect(x: 0, y: 0, width: boundSize.width, height: boundSize.height)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
    不延迟的加载方法
    
    :param: vc   主view
    :param: toVC 目标view
    */
    static func presentView(vc:UIViewController, toVC:UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            vc.presentViewController(toVC, animated: true, completion: nil)
        }
    }
    
    static func checkPhoneNum(num:String) -> Bool {
        return true
        /**
        * 手机号码
        * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
        * 联通：130,131,132,152,155,156,185,186
        * 电信：133,1349,153,180,189
        */
//        let MOBILE = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//        /**
//        10         * 中国移动：China Mobile
//        11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//        12         */
//        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//        /**
//        15         * 中国联通：China Unicom
//        16         * 130,131,132,152,155,156,185,186
//        17         */
//        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
//        /**
//        20         * 中国电信：China Telecom
//        21         * 133,1349,153,180,189
//        22         */
//        let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
//        /**
//        25         * 大陆地区固话及小灵通
//        26         * 区号：010,020,021,022,023,024,025,027,028,029
//        27         * 号码：七位或八位
//        28         */
//        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//        
//        var regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
//        var regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//        var regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//        var regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
//        if ((regextestmobile.evaluateWithObject(num) == true)
//            || (regextestcm.evaluateWithObject(num)  == true)
//            || (regextestct.evaluateWithObject(num) == true)
//            || (regextestcu.evaluateWithObject(num) == true))
//        {
//            return true
//        }
//        else
//        {
//            return false
//        }
    }
    
}

//MARK:SwiftyJson 扩展--
extension JSON {
    
    public init(jsonStr:String, dataEncoding:UInt = NSUTF8StringEncoding) {
        if let data = NSString(string: jsonStr).dataUsingEncoding(dataEncoding) {
            if let object:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil){
                self.init(object)
            } else {
                self.init(NSNull())
            }
        } else {
            self.init(NSNull())
        }
    }
}

extension NSDate {
    public static func dateFromInterval(timeInterval:Int) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(timeInterval / 1000))
    }
    
    
}


