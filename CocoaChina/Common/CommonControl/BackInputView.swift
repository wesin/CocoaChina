//
//  BackInputView.swift
//  HupunErp
//
//  Created by 何文新 on 15/3/19.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import UIKit

@IBDesignable
class BackInputView: UIView {
    
    @IBInspectable
    var marginX:CGFloat = 0
    @IBInspectable
    var marginY:CGFloat = 0
    @IBInspectable
    var lineYHeight:CGFloat = 5
    @IBInspectable
    var lineWidth:CGFloat = 1
    @IBInspectable
    var color = UIColor.grayColor()
    
    override func drawRect(rect: CGRect) {
        let line = UIBezierPath()
        line.lineWidth = lineWidth
        let beginPoint = CGPoint(x: marginX, y: bounds.height - marginY - lineYHeight)
        line.moveToPoint(beginPoint)
        line.addLineToPoint(CGPoint(x: marginX, y: bounds.height - marginY))
        line.addLineToPoint(CGPoint(x: bounds.width - marginX, y: bounds.height - marginY))
        line.addLineToPoint(CGPoint(x: bounds.width - marginX, y: bounds.height - marginY - lineYHeight))
        
        color.set()
        line.stroke()

    }
    
}
