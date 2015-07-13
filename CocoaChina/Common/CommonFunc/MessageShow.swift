//
//  ErrorMessageShow.swift
//  SwiftWebApi
//
//  Created by 何文新 on 15/2/11.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

enum MessageType {
    case Error
    case Show
    case Warn
}

class MessageShow {
    
    private let pAlertView = UIAlertView()
    private var queue:dispatch_queue_t?
    
    init(){
        queue = dispatch_get_main_queue()
    }
    
    var message :String = "" {
        willSet (newValue) {
            asyncShowMessage(MessageType.Show, withMessage: newValue)
        }
    }
    
    var errorMessage :String = "" {
        willSet (newValue) {
            asyncShowMessage(MessageType.Error, withMessage: newValue)
        }
    }
    
    private func asyncShowMessage(msgType:MessageType, withMessage message:String, boolAutoHide:Bool = false){
        dispatch_async(queue!, {
            var title:String
            switch(msgType){
            case .Error:
                title = "错误"
                break
            case .Warn:
                title = "警告"
                break
            default:
                title = "提示"
                break
            }
            self.pAlertView.title = title
            self.pAlertView.message = message
            if boolAutoHide {
                self.pAlertView.show()
                sleep(3)
                self.pAlertView.removeFromSuperview()
            } else {
                self.pAlertView.addButtonWithTitle("确定")
                self.pAlertView.show()
            }
            
        })
    }
    
    func showMessageAutoHide(msgType:MessageType, withMessage msg:String) {
        asyncShowMessage(msgType, withMessage: msg, boolAutoHide: true)
    }
    
    //MARK:Singleton--
    class var ShareInstance: MessageShow {
        struct Static {
            static let instance : MessageShow = MessageShow()
        }
        return Static.instance
    }
    
//    static func localNotification() {
////        var notification = UILocalNotification()
////        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
////        notification.timeZone = NSTimeZone.defaultTimeZone()
////        notification.repeatInterval = NSCalendarUnit.DayCalendarUnit
////        notification.alertBody = "hello, goodday!"
////        notification.userInfo = ["username":"wesin"]
////        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//    }
    
    
}
