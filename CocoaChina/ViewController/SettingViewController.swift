//
//  SettingViewController.swift
//  CocoaChina
//
//  Created by 何文新 on 15/7/24.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class SettingViewController:UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableSetting: UITableView!
    
    var headImage:UIImage?
    var myAlertView:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headImage = UIImage(contentsOfFile: PageDataCenter.instance.imageHeadName)
        tableSetting.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88
        }
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 2.5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = tableView.dequeueReusableCellWithIdentifier("headrowcell", forIndexPath: indexPath) as! HeadRowTableViewCell
            cell.imgHead.image = headImage
            return cell
        case (1,0):
            let cell = tableView.dequeueReusableCellWithIdentifier("leftrightcell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "清除缓存"
            cell.detailTextLabel?.text = String.localizedStringWithFormat("%.2fM", CommonFunc.folderSizeAtPath(PageDataCenter.instance.imagePath))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pickImage()
        case (1,0):
            clearCache()
        default:
            return
        }
    }
    
    func pickImage() {
        if myAlertView == nil {
            myAlertView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cameraBtn = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: {
                action -> Void in
                self.takePhoto(true)
            })
            let photoBtn = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.Default, handler: {
                action -> Void in
                self.takePhoto(false)
            })
            let cancelBtn = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {
                action -> Void in
                self.tableSetting.deselectRowAtIndexPath(self.tableSetting.indexPathForSelectedRow()!, animated: true)
            })
            myAlertView?.addAction(cancelBtn)
            myAlertView?.addAction(cameraBtn)
            myAlertView?.addAction(photoBtn)
        }
        self.presentViewController(myAlertView!, animated: true, completion: nil)
    }
    
    private func takePhoto(ifCamera:Bool) {
        let imageVC = UIImagePickerController()
        imageVC.sourceType = ifCamera ? .Camera : .PhotoLibrary
        imageVC.delegate = self
        imageVC.allowsEditing = true
        self.presentViewController(imageVC, animated: true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        headImage = image
        tableSetting.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        saveImage(image)
        
        NSNotificationCenter.defaultCenter().postNotificationName("changehead", object: image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    保存图片
    
    :param: img 图片
    */
    private func saveImage(img:UIImage) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            let fileManager = NSFileManager.defaultManager()
            let filePath = PageDataCenter.instance.imageHeadPath
            if !fileManager.fileExistsAtPath(filePath) {
                fileManager.createDirectoryAtPath(PageDataCenter.instance.imageHeadPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
            var data = UIImagePNGRepresentation(img)
            fileManager.createFileAtPath(PageDataCenter.instance.imageHeadName, contents: data, attributes: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clearCache() {
        PageDataCenter.instance.imageDic.removeAll()
        let manager = NSFileManager.defaultManager()
        manager.removeItemAtPath(PageDataCenter.instance.imagePath, error: nil)
        tableSetting.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
    }
}
