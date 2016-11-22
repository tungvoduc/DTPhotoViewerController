//
//  DTPhotoViewerController.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 29/04/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit


open class DTPhotoViewerController: UIViewController, DTPhotoViewer {
    ///
    /// Indicates if status bar should be hidden after photo viewer controller is presented.
    /// Default value is true
    ///
    open var shouldHideStatusBarOnPresent = true
    
    ///
    /// Indicates status bar style when photo viewer controller is being presenting
    /// Default value if UIStatusBarStyle.default
    ///
    open var statusBarStyleOnPresenting: UIStatusBarStyle = UIStatusBarStyle.default
    
    ///
    /// Indicates status bar animation style when changing hidden status
    /// Default value if UIStatusBarStyle.fade
    ///
    open var statusBarAnimationStyle: UIStatusBarAnimation = UIStatusBarAnimation.fade
    
    ///
    /// Indicates status bar style after photo viewer controller is being dismissing
    /// Include when pan gesture recognizer is active.
    /// Default value if UIStatusBarStyle.LightContent
    open var statusBarStyleOnDismissing: UIStatusBarStyle = UIStatusBarStyle.lightContent
    
    ///
    /// Background color
    ///
    open var backgroundColor: UIColor = UIColor.black
    
    ///
    /// Indicates where image should be scaled smaller then being dragged
    /// Default value is true
    ///
    open var scaleWhileDragging = true
    
    ///
    /// This variable sets original frame of image view to animate from
    ///
    open fileprivate(set) var originalFrame: CGRect = CGRect.zero
    
    
    /// Presenting size
    /// The final size after image View is presented.
    fileprivate var _presentedImageViewSize: CGSize = CGSize.zero
    
    
    //MARK: Private variables
    ///
    /// This is the image view that will animate from original frame to screen center
    ///
    open fileprivate(set) var imageView: UIImageView
    
    
    
    ///
    ///
    ///
    fileprivate weak var _referenceView: UIView?
    weak open var referenceView: UIView? {
        return _referenceView
    }
    
    
    ///
    ///
    ///
    open var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    ///
    ///
    ///
    open fileprivate(set) var scrollView: UIScrollView
    
    ///
    ///
    ///
    open fileprivate(set) var backgroundView: UIView
    
    ///
    /// Pan gesture interacting with dragging image view
    ///
    fileprivate var _panGestureRecognizer: UIPanGestureRecognizer!
    
    ///
    ///
    ///
    fileprivate var _shouldHideStatusBar = false
    
    ///
    ///
    ///
    fileprivate var _defaultStatusBarStyle = false
    
    ///
    /// Transition animator
    /// Customizable if you wish to provide your own transitions.
    ///
    open lazy var animator: DTPhotoViewerBaseAnimator = DTPhotoAnimator()
    
    public init?(referenceView: UIView?, image: UIImage?) {
        if let newImage = image {
            scrollView = UIScrollView(frame: CGRect.zero)
            backgroundView = UIView(frame: CGRect.zero)
            imageView = UIImageView(frame: CGRect.zero)
            
            super.init(nibName: nil, bundle: nil)
            
            transitioningDelegate = self
            _referenceView = referenceView
            self.image = newImage
            
            modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            modalPresentationCapturesStatusBarAppearance = true
        }
        else {
            return nil
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        //Calculate originalFrame
        if let view = referenceView {
            if let superview = view.superview {
                let frame = (superview.convert(view.frame, to: self.view))
                
                if abs(frame.size.width - view.frame.size.width) > 1 {
                    // This is workaround for bug in ios 8, everything is double.
                    originalFrame = CGRect(x: frame.origin.x/2, y: frame.origin.y/2, width: frame.size.width/2, height: frame.size.height/2)
                }
                else {
                    originalFrame = frame
                }
            }
            
            // Content mode should be identical between image view and reference view
            imageView.contentMode = view.contentMode
        }
        else {
            // Work around when there is no reference view, dragging might behave oddly
            // Should be fixed in the future
            originalFrame = CGRect(x: self.view.frame.midX - 0.5, y: self.view.frame.midY - 0.5, width: 1, height: 1)
        }
        
        //Background view
        view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = self.backgroundColor
        
        //Image view
        imageView.frame = originalFrame
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        
        //Scroll view
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        //Tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tapGesture)
        
        //Double tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(_handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        tapGesture.require(toFail: doubleTapGesture)
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        //Pan gesture recognizer
        _panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(_handlePanGesture))
        scrollView.addGestureRecognizer(_panGestureRecognizer)
        
        super.viewDidLoad()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = self.view.bounds
        scrollView.frame = self.view.bounds
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !animated {
            self.presentingAnimation()
            self.presentingEnded()
        }
        else {
            if let referenceView = _referenceView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = referenceView.layer.cornerRadius
                animation.toValue = 0
                animation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "cornerRadius")
                imageView.layer.cornerRadius = 0
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderColorAnimation.fromValue = referenceView.layer.borderColor
                borderColorAnimation.toValue = UIColor.clear.cgColor
                borderColorAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderColor")
                imageView.layer.borderColor = UIColor.clear.cgColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderWidthAnimation.fromValue = referenceView.layer.borderWidth
                borderWidthAnimation.toValue = 0
                borderWidthAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderWidth")
                imageView.layer.borderWidth = referenceView.layer.borderWidth
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imageViewerControllerDidFinishPresentingAnimation()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !animated {
            self.dismissingAnimation()
            self.dismissingEnded()
        }
        else {
            if let referenceView = _referenceView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = 0
                animation.toValue = referenceView.layer.cornerRadius
                animation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "cornerRadius")
                imageView.layer.cornerRadius = referenceView.layer.cornerRadius
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderColorAnimation.fromValue = UIColor.clear.cgColor
                borderColorAnimation.toValue = referenceView.layer.borderColor
                borderColorAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderColor")
                imageView.layer.borderColor = referenceView.layer.borderColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderWidthAnimation.fromValue = 0
                borderWidthAnimation.toValue = referenceView.layer.borderWidth
                borderWidthAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderWidth")
                imageView.layer.borderWidth = referenceView.layer.borderWidth
            }
        }
    }
    
    open override var prefersStatusBarHidden : Bool {
        if shouldHideStatusBarOnPresent {
            return _shouldHideStatusBar
        }
        return false
    }
    
    open override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return statusBarAnimationStyle
    }
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if _defaultStatusBarStyle {
            return statusBarStyleOnPresenting
        }
        return statusBarStyleOnDismissing
    }
    
    fileprivate func startAnimation() {
        //Hide reference image view
        _referenceView?.isHidden = true
        
        //Animate to center
        _animateToCenter()
    }
    
    func _animateToCenter() {
        UIView.animate(withDuration: animator.presentingDuration, animations: {
            self.presentingAnimation()
        }) { (finished) in
            // Presenting animation
            self.presentingEnded()
            self.imageViewerControllerDidFinishPresentingAnimation()
        }
    }
    
    func _dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        // Single tap
        self.imageViewerControllerDidTapImageView()
    }
    
    func _handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imageView)
        if let center = gesture.view?.superview?.convert(location, to: scrollView) {
            // Double tap
            self.imageViewerControllerDidDoubleTapImageView()
            
            if (scrollView.zoomScale == scrollView.maximumZoomScale) {
                // Zoom out
                scrollView.minimumZoomScale = 1.0
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
                
            } else {
                // Zoom in
                scrollView.minimumZoomScale = 1.0
                let rect = self.zoomRectForScrollView(scrollView, withScale: scrollView.maximumZoomScale, withCenter: center)
                scrollView.zoom(to: rect, animated: true)
            }
        }
    }
    
    func _handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if let view = gesture.view {
            switch gesture.state {
            case .began:
                //Make status bar visible when beginning to drag image view
                _shouldHideStatusBar = false
                _defaultStatusBarStyle = false
                
                // Dragged
                self.imageViewerControllerWillDragImageView()
                
                setNeedsStatusBarAppearanceUpdate()
                
            case .changed:
                let translation = gesture.translation(in: view)
                self.imageView.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
                
                //Change opacity of background view based on vertical distance from center
                let yDistance = CGFloat(abs(self.imageView.center.y - self.view.center.y))
                let alpha = 1.0 - yDistance/(self.view.center.y)
                self.backgroundView.alpha = alpha
                
                //Scale image
                //Should not go smaller than max ratio
                if scaleWhileDragging {
                    let ratio = max(originalFrame.size.height/imageView.frame.height, originalFrame.size.width/imageView.frame.width)
                    
                    //If alpha = 0, then scale is max ratio, if alpha = 1, then scale is 1
                    let scale = 1 + (1 - alpha)*(ratio - 1)
                    //imageView.transform = CGAffineTransformMakeScale(scale, scale)
                    // Do not use transform to scale down image view
                    // Instead change width & height
                    print("scale = \(scale)\n")
                    
                    if scale < 1 && scale >= ratio {
                        imageView.frame.size = CGSize(width: _presentedImageViewSize.width * scale, height: _presentedImageViewSize.height * scale)
                    }
                }
                
            default:
                //Animate back to center
                if self.backgroundView.alpha < 0.8 {
                    _dismiss()
                }
                else {
                    _animateToCenter()
                }
            }
        }
    }
    
    open func presentingAnimation() {
        //Hide reference view
        _referenceView?.isHidden = true
        
        //Calculate final frame
        let size = image.size
        var destinationFrame = CGRect.zero
        
        destinationFrame.size.width = view.frame.size.width
        destinationFrame.size.height = view.frame.size.width * (size.height / size.width)
        
        // Store presented size
        _presentedImageViewSize = destinationFrame.size
        
        //Animate image view to the center
        self.imageView.frame = destinationFrame
        self.imageView.center = self.view.center
        
        //Change status bar to black style
        self._defaultStatusBarStyle = true
        self._shouldHideStatusBar = true
        self.setNeedsStatusBarAppearanceUpdate()
        
        //Animate background alpha
        self.backgroundView.alpha = 1.0
    }
    
    open func dismissingAnimation() {
        self.imageView.frame = self.originalFrame
        self.backgroundView.alpha = 0
    }
    
    open func presentingEnded() {
        
    }
    
    open func dismissingEnded() {
        self._referenceView?.isHidden = false
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension DTPhotoViewerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}


//MARK: - UIScrollViewDelegate
extension DTPhotoViewerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.updateFrameFor(self.view.frame.size)
        
        //Disable pan gesture if zoom scale is not 1
        if scrollView.zoomScale != 1 {
            _panGestureRecognizer.isEnabled = false
        }
        else {
            _panGestureRecognizer.isEnabled = true
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageViewerControllerWillDragImageView()
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        imageViewerControllerWillZoom()
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageViewerControllerDidZoom(scale)
    }
    
    fileprivate func _updateZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let zoomScale = min(widthScale, heightScale)
        
        scrollView.maximumZoomScale = zoomScale
    }
    
    fileprivate func zoomRectForScrollView(_ scrollView: UIScrollView, withScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        // The zoom rect is in the content view's coordinates.
        // At a zoom scale of 1.0, it would be the size of the
        // imageScrollView's bounds.
        // As the zoom scale decreases, so more content is visible,
        // the size of the rect grows.
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width  = scrollView.frame.size.width  / scale
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    fileprivate func updateFrameFor(_ size: CGSize) {
        
        let y = max(0, (size.height - imageView.frame.height) / 2)
        let x = max(0, (size.width - imageView.frame.width) / 2)
        
        imageView.frame.origin = CGPoint(x: x, y: y)
    }
}

//MARK: Required overriding methods
extension DTPhotoViewerController {
    open func imageViewerControllerWillDragImageView() {
        // assert(false, "This method must be overriden by the subclass")
    }
    
    open func imageViewerControllerDidFinishPresentingAnimation() {
        // assert(false, "This method must be overriden by the subclass")
    }
    
    open func imageViewerControllerDidTapImageView() {
        // assert(false, "This method must be overriden by the subclass")
    }
    
    open func imageViewerControllerDidDoubleTapImageView() {
        // assert(false, "This method must be overriden by the subclass")
    }
    
    open func imageViewerControllerDidZoom(_ zoomScale: CGFloat) {
        // assert(false, "This method must be overriden by the subclass")
    }
    
    open func imageViewerControllerWillZoom() {
        // assert(false, "This method must be overriden by the subclass")
    }
}
