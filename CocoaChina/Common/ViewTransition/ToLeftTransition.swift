//
//  File.swift
//  HupunErp
//
//  Created by 何文新 on 15/6/15.
//  Copyright (c) 2015年 Hupun. All rights reserved.
//

import UIKit

class ToLeftTransition:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1. Get controllers from transition context
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let screenBounds = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(toView!)
        toView?.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0)
        
        let containerView = transitionContext.containerView()
        containerView.addSubview(toView!.view)
        
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay:0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            () -> Void in
            toView?.view.frame = finalFrame
            }, completion: {
                (t) -> Void in
                transitionContext.completeTransition(true)
        })
    }
}

