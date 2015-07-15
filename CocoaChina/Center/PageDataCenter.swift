//
//  PageDataCentre.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/14.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import Foundation

let mainUrl = "http://www.cocoachina.com"

class PageDataCenter:NSObject {
    
    private static let a = PageDataCenter()
    
    static var instance : PageDataCenter {
        return a
    }
    //缓存的条目信息
    var dataAll = [ListType:[DataContent]]()
    
    //缓存的图片信息
    var imageDic = [String:String]()
    
    var imagePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("Image")
    //        let documentPath: AnyObject = path[0] NSHomeDirectory().stringByAppendingPathComponent("Image")
    
    func loadImageAsync() {

        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            for (key,value) in self.dataAll {
                value.map() {
                   (t) -> Void in
                    self.loadImage(t.imgurl)
                }
            }
        }
    }
    
    /**
    根据url地址获取图片
    
    :param: imgUrl	图片地址
    
    :returns: 返回图片数据
    */
    func loadImage(imgUrl:String) -> NSData? {
        var imgRealUrl = imgUrl
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(imagePath) {
            fileManager.createDirectoryAtPath(imagePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        if imgUrl.hasPrefix("/") {
            imgRealUrl = mainUrl + imgUrl
        }
        if let fileName = imageDic[imgRealUrl] {
            //            return fileName
            return NSData(contentsOfFile:  imagePath.stringByAppendingPathComponent(fileName))
        }
        //检查是不是已经存在该文件
        let fileName = imgRealUrl.substringFromIndex(imgRealUrl.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)!.endIndex)
        let filePath = imagePath.stringByAppendingPathComponent(fileName)
        if fileManager.fileExistsAtPath(filePath) {
            imageDic[fileName] = fileName
            return NSData(contentsOfFile: filePath)
        }
        //无奈了只能去服务端重新取了
        if let url = NSURL(string: imgRealUrl) {
            if let data = NSData(contentsOfURL: url) {
                fileManager.createFileAtPath(imagePath.stringByAppendingPathComponent(fileName), contents: data, attributes: nil)
                imageDic[imgRealUrl] = fileName
                return data
            }
        }
        return nil
    }
}
