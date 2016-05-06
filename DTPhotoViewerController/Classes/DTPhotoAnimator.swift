//
//  DTPhotoAnimator.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 04/05/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit

enum DTPhotoAnimatorType {
    case Dismissing
    case Presenting
}

class DTPhotoAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    ///
    /// Preseting transition duration
    /// Default value is 0.5
    ///
    var presentingDuration: NSTimeInterval = 0.2
    
    ///
    /// Dismissing transition duration
    /// Default value is 0.5
    ///
    var dismissingDuration: NSTimeInterval = 0.2
    
    ///
    /// Type of animator
    /// Default value is Presenting
    ///
    var type = DTPhotoAnimatorType.Presenting
    
    ///
    /// Indicates if using spring animation
    /// Default value is true
    ///
    var spring = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        //return correct duration
        var duration = type == .Presenting ? presentingDuration : dismissingDuration
        if spring {
            //Spring animation's duration should be longer than normal animation
            duration = duration * 2.5
        }
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let duration = self.transitionDuration(transitionContext)
        
        if type == .Presenting {
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as? DTPhotoViewerController else {
                fatalError("view controller does not conform DTPhotoViewer")
            }
            let fromView = fromViewController.view
            let toView = toViewController.view
            
            let completeTransition: () -> () = {
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
                UIApplication.sharedApplication().keyWindow!.addSubview(toViewController.view)
                
                if isCancelled {
                    container.insertSubview(toView, belowSubview: fromView)
                }
            }
            
            container.addSubview(fromView)
            container.addSubview(toView)
            
            if spring {
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    //Animate image view to the center
                    toViewController.presentingAnimation()
                    }, completion: { (finished) in
                        toViewController.presentingEnded()
                        completeTransition()
                })
            }
            else {
                UIView.animateWithDuration(duration, animations: {
                    //Animate image view to the center
                    toViewController.presentingAnimation()
                }) { (finished) in
                    //Hide status bar
                    toViewController.presentingEnded()
                    completeTransition()
                }
            }
            
        }
        else {
            guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? DTPhotoViewerController else {
                fatalError("view controller does not conform DTPhotoViewer")
            }
            
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            let fromView = fromViewController.view
            let toView = toViewController.view
            
            let completeTransition: () -> () = {
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
                UIApplication.sharedApplication().keyWindow!.addSubview(toViewController.view)
                
                if isCancelled {
                    container.insertSubview(toView, belowSubview: fromView)
                }
            }
            
            container.addSubview(toView)
            container.addSubview(fromView)
            
            if spring {
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    //Animate image view to the center
                    fromViewController.dismissingAnimation()
                    }, completion: { (finished) in
                        //End transition
                        fromViewController.dismissingEnded()
                        completeTransition()
                })
            }
            else {
                UIView.animateWithDuration(duration, animations: {
                    //Animate image view to the center
                    fromViewController.dismissingAnimation()
                    
                }) { (finished) in
                    //End transition
                    fromViewController.dismissingEnded()
                    completeTransition()
                }
            }
        }
    }
    
    func animationEnded(transitionCompleted: Bool) {
        
    }
}
