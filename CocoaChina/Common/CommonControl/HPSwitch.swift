//
//  HPLoginSwitch.swift
//  HupunErp
//
//  Created by 何文新 on 15/5/19.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

protocol HPSwitchDelegate:class {
    func switchClick(switchBtn:HPSwitch, atIndex index:Int)
}

class HPSwitch: UIView {
    
    weak var delegate:HPSwitchDelegate?
    var arrayTitle:[String]?
    
    @IBInspectable
    var drawLineColor = UIColor(red: 212 / 255, green: 213 / 255, blue: 214 / 255, alpha: 1)
    
    @IBInspectable
    var fontColor = UIColor(red: 212 / 255, green: 213 / 255, blue: 214 / 255, alpha: 1)
    
    @IBInspectable
    var imgWidth:CGFloat = 1
    
    @IBInspectable
    var separateChar:String = ""
    
    @IBInspectable
    var separateBGColor:UIColor = UIColor(red: 212 / 255, green: 213 / 255, blue: 214 / 255, alpha: 1)
    
    @IBInspectable
    var selectColor:UIColor = UIColor(red: 0, green: 114 / 255, blue: 206 / 255, alpha: 1)
    
    @IBInspectable
    var lastSelectIndex:Int = 0
    @IBInspectable
    var allowClick:Bool = true
    
    private var selectLayer:CALayer?
    private var arrayLabel = [UILabel]()
    private var labelWidth:CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        if arrayTitle == nil {
            return
        }
        if selectLayer == nil {
            labelWidth = (bounds.width - CGFloat(arrayTitle!.count) * imgWidth) / CGFloat(arrayTitle!.count)
            drawControls()
            
            //画下边的分割线
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: rect.height))
            path.addLineToPoint(CGPoint(x: rect.width, y: rect.height))
            drawLineColor.set()
            path.stroke()
            
            selectLayer = CALayer()
            selectLayer?.backgroundColor = selectColor.CGColor
            self.layer.insertSublayer(selectLayer!, atIndex: 0)
            drawSelectItem(lastSelectIndex)
            
            if allowClick {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(HPSwitch.click(_:)))
                gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                self.addGestureRecognizer(gesture)
            }
        }
    }
    
    func drawControls() {
        var index = 0
        for item in arrayTitle! {
            let labelX = CGFloat(index) * (imgWidth + labelWidth)
            let label = UILabel(frame: CGRect(x: labelX, y: 0, width: labelWidth, height: bounds.height))
            label.textColor = index == lastSelectIndex ? selectColor : fontColor
            label.textAlignment = .Center
            label.font = UIFont(name: "System", size: 5)
            self.addSubview(label)
            arrayLabel.append(label)
            label.text = item
            if index != arrayTitle!.count - 1 {
                let separateView = UILabel(frame: CGRect(x: labelX + labelWidth , y: 2, width: imgWidth, height: bounds.height - 4))
                self.addSubview(separateView)
                separateView.backgroundColor = separateBGColor
                separateView.text = separateChar
                separateView.textAlignment = .Center
                separateView.textColor = fontColor
            }
            index += 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func click(gesture:UIGestureRecognizer) {
        let position = gesture.locationInView(self)
        let index = Int(position.x / (bounds.width / CGFloat(arrayTitle!.count)))
        if lastSelectIndex == index {
            return
        }
        clearSelectItem()
        lastSelectIndex = index
        drawSelectItem(index)
        delegate?.switchClick(self, atIndex: index)
    }
    
    func drawSelectItem(index:Int) {
        let selectLabel = arrayLabel[index]
        selectLabel.textColor = selectColor
        selectLayer?.frame = CGRect(x: CGFloat(index) * (labelWidth + imgWidth), y: bounds.height - 2, width: labelWidth, height: 2)
    }
    
    func clearSelectItem() {
        arrayLabel[lastSelectIndex].textColor = fontColor
    }
    
    
}
