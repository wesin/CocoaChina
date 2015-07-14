//
//  MainViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/10.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

enum ListType:Int {
    case Main = 0
    case New = 1
    case Special = 2
    case Hotpost = 3
    case Search = 4
}

class MainViewController:ListCommonViewController, HPSwitchDelegate {
    
    @IBOutlet weak var switchSeg: HPSwitch!
    
    @IBOutlet weak var tableMain: UITableView!
    
    var url = "http://www.cocoachina.com"
    var pageType = ListType.Main
    
    @IBOutlet weak var tabItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchSeg.arrayTitle = ["推荐", "最新", "专题", "热帖", "搜索"]
        switchSeg.delegate = self
        tableMain.contentInset = UIEdgeInsetsMake(2.5, 0, 0, 0)
        tableMain.registerNib(UINib(nibName: "ListRowCell", bundle: nil), forCellReuseIdentifier: "listrowcell")
        dataSource = PageDataCenter.instance.dataAll[ListType.Main]
    }
    
    @IBAction func showLeading(sender: AnyObject) {
        
    }
    
    override func refreshView() {
        tableMain.reloadData()
    }
    
    //HPSwitchDelegate
    func switchClick(switchBtn: HPSwitch, atIndex index: Int) {
        var type = ListType(rawValue: index)!
        dataSource = PageDataCenter.instance.dataAll[type]
        refreshView()
    }
    
}
