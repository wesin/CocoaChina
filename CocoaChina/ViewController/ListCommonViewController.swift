//
//  ListCommonViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit
import WebKit

enum MessageHandler:String {
    case MainHandler = "mainhandler"
    case ContentHandler = "contenthandler"
    case SearchHandler = "searchhandler"
}

class ListCommonViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    var dataSource:[DataContent]?
    
    var pageType = ListType.Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    //MARK:UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let content = dataSource![indexPath.row]
        switch pageType {
        case .Main, .Special:
            let cell = tableView.dequeueReusableCellWithIdentifier("listrowdetailcell", forIndexPath: indexPath) as! ListRowDetailTableViewCell
            if let data = PageDataCenter.instance.loadImage(content.imgurl) {
                cell.imgTitle.image = UIImage(data: data)
            }
            cell.labelTitle.text = content.title
            cell.labelDetail.text = content.content
            return cell
        case .New:
            let cell = tableView.dequeueReusableCellWithIdentifier("listrowcell", forIndexPath: indexPath) as! ListRowTableViewCell
            
            if let data = PageDataCenter.instance.loadImage(content.imgurl) {
                cell.imgTitle.image = UIImage(data: data)
            }
            cell.labelTitle.text = content.title
            cell.labelTime.text = content.time
            return cell
        case .Favorite:
            let cell = tableView.dequeueReusableCellWithIdentifier("favoriterowcell", forIndexPath: indexPath) as! FavoriteRowTableViewCell
            cell.labelTitle?.text = content.title
            cell.labelTime?.text = content.time
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let content = dataSource![indexPath.row]
        let detailView = CommonFunc.getViewFromStoryBoard("Main", viewIndetifier: "viewdetail") as! DetailViewController
        detailView.content = content
        detailView.transitioningDelegate = self
        self.presentViewController(detailView, animated: true, completion: nil)
    }
    
    //MARK:UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToLeftTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ToRightTransition()
    }

}
