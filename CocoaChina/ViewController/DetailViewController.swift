//
//  DetailViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var content:DataContent?
    var data:SugarRecordResults?
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = content?.title
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("share"))
        rightButton.tintColor = UIColor.whiteColor()
        let rightButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: Selector("store:"))
        rightButton2.tintColor = UIColor.whiteColor()
        navItem.rightBarButtonItems = [rightButton, rightButton2]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if content!.url.hasPrefix("/") {
            content?.url = mainUrl + content!.url
        }
        CalculateFunc.beginPage("Detail:" + content!.url)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        CalculateFunc.endPage("Detail:" + content!.url)
    }
    
    deinit {
        print("Detail deinit")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webView = segue.destinationViewController as! WKDetailViewController
        if content!.url.hasPrefix("/") {
            content?.url = mainUrl + content!.url
        }
        webView.url = content!.url
    }
    
    @IBAction func store(sender: AnyObject) {
        let item = Favorite.create() as! Favorite
        item.date = NSDate()
        item.title = content!.title
        item.url = content!.url
        item.save()
        let hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
//        hud.delegate = self
        hud.labelText = "收藏成功"
        hud.show(true)
        hud.hide(true, afterDelay: 1)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func share() {
        let imageData = PageDataCenter.instance.loadImageLoacation(content!.imgurl)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: "55b8690c67e58eb791000762", shareText: content?.title, shareImage: UIImage(data: imageData!), shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline], delegate: nil)
        UMSocialData.defaultData().extConfig.wechatSessionData.url = content!.url
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = content!.url
        
    }
}
