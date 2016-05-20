//
//  CommonFunc.swift
//  SwiftEasyStock
//
//  Created by 何文新 on 15/2/21.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit


var bgView:UIView?                          //显示过滤页面时出现的一个黑色遮盖页面

class CommonFunc:NSObject {
    
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
        for (index, value) in array.enumerate() {
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
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
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
    
    //MARK:FoldSize
    
    /**
    获取文件大小
    
    - parameter path:	路径
    
    - returns: 大小
    */
    static func fileSizeAtPath(path:NSURL) -> Double {
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(path.path!) {
            return 0
        }
        return (try! manager.attributesOfItemAtPath(path.path!))[NSFileSize as NSObject as! String] as! Double
    }
    
    /**
    获取文件夹大小
    
    - parameter path:	路径
    
    - returns: 多少M
    */
    static func folderSizeAtPath(path:NSURL) -> Double {
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(path.path!) {
            return 0
        }
        var folderSize = 0.0
        //深路径搜索，返回所有文件包括子文件夹里面文件的路径
       _ = manager.subpathsAtPath(path.path!)?.map({
            (subPath:String) -> Void in
            folderSize += self.fileSizeAtPath(path.URLByAppendingPathComponent(subPath))
        })
        return folderSize / (1024 * 1024)
    }
    
    /**
    不延迟的加载方法
    
    - parameter vc:   主view
    - parameter toVC: 目标view
    */
    static func presentView(vc:UIViewController, toVC:UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            vc.presentViewController(toVC, animated: true, completion: nil)
        }
    }
    
    func checkPhoneNum(num:String) -> Bool {
        return true
    }
    
    static func changeUserAgent(boolLocal:Bool) {
        let agent = boolLocal ? standUserAgent : newUserAgent
        let dic = ["UserAgent":agent]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic)
    }
}
