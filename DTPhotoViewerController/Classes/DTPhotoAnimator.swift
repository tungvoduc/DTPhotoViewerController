//
//  DTPhotoAnimator.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 04/05/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit

private let kInitialSpringVelocity: CGFloat = 2.0
private let kDamping: CGFloat = 0.75

///
/// If you wish to provide a custom transition animator, you just need to create a new class
/// that conforms this protocol and assign
///
public protocol DTPhotoViewerBaseAnimator: NSObjectProtocol, UIViewControllerAnimatedTransitioning {
    var presentingDuration: TimeInterval {get set}
    var dismissingDuration: TimeInterval {get set}
}

class DTPhotoAnimator: NSObject, DTPhotoViewerBaseAnimator {
    ///
    /// Preseting transition duration
    /// Default value is 0.2
    ///
    var presentingDuration: TimeInterval = 0.2
    
    ///
    /// Dismissing transition duration
    /// Default value is 0.5
    ///
    var dismissingDuration: TimeInterval = 0.2
    
    ///
    /// Indicates if using spring animation
    /// Default value is true
    ///
    var spring = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //return correct duration
        let fromViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
        let viewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)
        let presenting = viewController?.presentingViewController == fromViewController
        var duration = presenting ? presentingDuration : dismissingDuration
        if spring {
            //Spring animation's duration should be longer than normal animation
            duration = duration * 2.5
        }
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presenting = toViewController.presentingViewController == fromViewController
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        if presenting {
            guard let photoViewerController = toViewController as? DTPhotoViewerController else {
                fatalError("view controller does not conform DTPhotoViewer")
            }
            
            let toView = toViewController.view!
            toView.frame = container.bounds
            
            let completeTransition: () -> () = {
                let isCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!isCancelled)
                
                if !isCancelled {
                    photoViewerController.presentationAnimationDidFinish()
                }
                
                // View controller appearance status
                toViewController.endAppearanceTransition()
                fromViewController.endAppearanceTransition()
            }
            
            container.addSubview(toView)
            
            if spring {
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: kDamping, initialSpringVelocity: kInitialSpringVelocity, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //Animate image view to the center
                    photoViewerController.presentingAnimation()
                }, completion: { (finished) in
                    completeTransition()
                })
            }
            else {
                UIView.animate(withDuration: duration, animations: {
                    //Animate image view to the center
                    photoViewerController.presentingAnimation()
                }, completion: { (finished) in
                    completeTransition()
                })
            }
            
        }
        else {
            guard let photoViewerController = fromViewController as? DTPhotoViewerController else {
                fatalError("view controller does not conform DTPhotoViewer")
            }
            
            let completeTransition: () -> () = {
                let isCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!isCancelled)
                
                if !isCancelled {
                    photoViewerController.dismissalAnimationDidFinish()
                }
                
                // View controller appearance status
                toViewController.endAppearanceTransition()
                fromViewController.endAppearanceTransition()
            }
            
            if spring {
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: kDamping, initialSpringVelocity: kInitialSpringVelocity, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //Animate image view to the center
                    photoViewerController.dismissingAnimation()
                }, completion: { (finished) in
                    //End transition
                    completeTransition()
                })
            }
            else {
                UIView.animate(withDuration: duration, animations: {
                    //Animate image view to the center
                    photoViewerController.dismissingAnimation()
                    
                }, completion: { (finished) in
                    //End transition
                    completeTransition()
                })
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
