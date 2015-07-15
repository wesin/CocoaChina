//
//  DetailViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var content:DataContent?
    
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = content?.title
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webView = segue.destinationViewController as! WKDetailViewController
        if content!.url.hasPrefix("/") {
            content?.url = mainUrl + content!.url
        }
        webView.url = content!.url
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
