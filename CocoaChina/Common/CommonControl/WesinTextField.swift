//
//  WesinTextField.swift
//  HupunErp
//
//  Created by 何文新 on 15/3/19.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

@IBDesignable
class WesinTextField: UITextField {
    
    var marginX:CGFloat = 0
    var marginY:CGFloat = 0
    
    @IBInspectable
    var lineYHeightScale:CGFloat = 2 / 10
    @IBInspectable
    var lineWidth:CGFloat = 2
    @IBInspectable
    var lineColor:UIColor = UIColor(red: 0.8902, green: 0.8902, blue: 0.8902, alpha: 1)
    @IBInspectable
    var highLineColor:UIColor = UIColor(red: 0.6353, green: 0.7843, blue: 0.8667, alpha: 1)
    @IBInspectable
    var needLine:Bool = true
    
    @IBInspectable
    var borderColor:UIColor = UIColor.blackColor()
    ///标识符
    var key = ""
    
    override func drawRect(rect: CGRect) {
        if needLine {
            let line = UIBezierPath()
            line.lineWidth = lineWidth
            let beginPoint = CGPoint(x: bounds.origin.x + marginX, y: bounds.origin.y + bounds.height - marginY - lineYHeightScale * bounds.height)
            line.moveToPoint(beginPoint)
            line.addLineToPoint(CGPoint(x: bounds.origin.x + marginX, y: bounds.origin.y + bounds.height - marginY))
            line.addLineToPoint(CGPoint(x: bounds.origin.x + bounds.width - marginX, y: bounds.origin.y + bounds.height - marginY))
            line.addLineToPoint(CGPoint(x: bounds.origin.x + bounds.width - marginX, y: bounds.origin.y + bounds.height - marginY - lineYHeightScale * bounds.height))
            
            lineColor.set()
            
            if highlighted {
                highLineColor.set()
            } else {
                lineColor.set()
            }
            
            line.stroke()
        }
        if self.borderStyle != UITextBorderStyle.None {
            self.layer.borderColor = borderColor.CGColor
            self.layer.borderWidth = 1
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        highlighted = true
        setNeedsDisplay()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        highlighted = false
        setNeedsDisplay()
        return super.resignFirstResponder()
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    
}
