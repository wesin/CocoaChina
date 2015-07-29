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
        println("Detail deinit")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webView = segue.destinationViewController as! WKDetailViewController
        if content!.url.hasPrefix("/") {
            content?.url = mainUrl + content!.url
        }
        webView.url = content!.url
    }
    
    @IBAction func store(sender: AnyObject) {
        let favoriteCenter = FavoriteCenter.instance
        var item = Favorite.create() as! Favorite
        item.date = NSDate()
        item.title = content!.title
        item.url = content!.url
        item.save()
        var hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
//        hud.delegate = self
        hud.labelText = "收藏成功"
        hud.show(true)
        hud.hide(true, afterDelay: 2)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
