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
public protocol DTPhotoViewerBaseAnimator: UIViewControllerAnimatedTransitioning {
    var presentingDuration: TimeInterval {get set}
    var dismissingDuration: TimeInterval {get set}
    var spring: Bool { get set }
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
        let duration = transitionDuration(using: transitionContext)
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presenting = toViewController.presentingViewController == fromViewController
        
        fromViewController.beginAppearanceTransition(false, animated: transitionContext.isAnimated)
        toViewController.beginAppearanceTransition(true, animated: transitionContext.isAnimated)
        
        if presenting {
            guard let photoViewerController = toViewController as? DTPhotoViewerController else {
                fatalError("view controller does not conform DTPhotoViewer")
            }
            
            let toView = toViewController.view!
            toView.frame = transitionContext.finalFrame(for: toViewController)
            
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
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: kDamping, initialSpringVelocity: kInitialSpringVelocity, options: UIView.AnimationOptions.curveEaseOut, animations: {
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
            
            // Layer animation
            if let referencedView = photoViewerController.referencedView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = referencedView.layer.cornerRadius
                animation.toValue = 0
                animation.duration = presentingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "cornerRadius")
                photoViewerController.imageView.layer.cornerRadius = 0
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                borderColorAnimation.fromValue = referencedView.layer.borderColor
                borderColorAnimation.toValue = UIColor.clear.cgColor
                borderColorAnimation.duration = presentingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "borderColor")
                photoViewerController.imageView.layer.borderColor = UIColor.clear.cgColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                borderWidthAnimation.fromValue = referencedView.layer.borderWidth
                borderWidthAnimation.toValue = 0
                borderWidthAnimation.duration = presentingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "borderWidth")
                photoViewerController.imageView.layer.borderWidth = referencedView.layer.borderWidth
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
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: kDamping, initialSpringVelocity: kInitialSpringVelocity, options: UIView.AnimationOptions.curveEaseOut, animations: {
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
            
            // Layer animation
            if let referencedView = photoViewerController.referencedView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = 0
                animation.toValue = referencedView.layer.cornerRadius
                animation.duration = dismissingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "cornerRadius")
                photoViewerController.imageView.layer.cornerRadius = referencedView.layer.cornerRadius
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                borderColorAnimation.fromValue = UIColor.clear.cgColor
                borderColorAnimation.toValue = referencedView.layer.borderColor
                borderColorAnimation.duration = dismissingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "borderColor")
                photoViewerController.imageView.layer.borderColor = referencedView.layer.borderColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                borderWidthAnimation.fromValue = 0
                borderWidthAnimation.toValue = referencedView.layer.borderWidth
                borderWidthAnimation.duration = dismissingDuration
                photoViewerController.imageView.layer.add(animation, forKey: "borderWidth")
                photoViewerController.imageView.layer.borderWidth = referencedView.layer.borderWidth
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
