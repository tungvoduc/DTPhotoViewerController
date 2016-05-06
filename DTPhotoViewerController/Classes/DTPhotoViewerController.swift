//
//  DTPhotoViewerController.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 29/04/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit

public class DTPhotoViewerController: UIViewController, DTPhotoViewer, UIViewControllerTransitioningDelegate, UIScrollViewDelegate {
    ///
    /// Indicates if status bar should be hidden after photo viewer controller is presented.
    /// Default value is true
    ///
    public var shouldHideStatusBarOnPresent = true
    
    ///
    /// Indicates status bar style when photo viewer controller is being presenting
    /// Default value if UIStatusBarStyle.Default
    ///
    public var statusBarStyleOnPresenting: UIStatusBarStyle = UIStatusBarStyle.Default
    
    ///
    /// Indicates status bar style after photo viewer controller is being dismissing
    /// Include when pan gesture recognizer is active.
    /// Default value if UIStatusBarStyle.LightContent
    public var statusBarStyleOnDismissing: UIStatusBarStyle = UIStatusBarStyle.LightContent
    
    ///
    /// Background color
    ///
    public var backgroundColor: UIColor = UIColor.blackColor()
    
    ///
    /// Indicates where image should be scaled smaller then being dragged
    /// Default value is true
    ///
    public var scaleWhileDragging = true
    
    ///
    /// This variable sets original frame of image view to animate from
    ///
    public var originalFrame: CGRect {
        return _originalFrame
    }
    
    private var _originalFrame: CGRect = CGRect.zero
    
    
    //MARK: Private variables
    ///
    /// This is the image view that will animate from original frame to screen center
    ///
    private var _imageView: UIImageView!
    public var imageView: UIImageView {
        return _imageView
    }
    
    ///
    ///
    ///
    private weak var _referenceView: UIView?
    weak public var referenceView: UIView? {
        return _referenceView
    }
    
    
    ///
    ///
    ///
    private var _image: UIImage!
    public var image: UIImage {
        return _image
    }
    
    ///
    ///
    ///
    private var _scrollView: UIScrollView!
    
    ///
    ///
    ///
    private var _backgroundView: UIView!
    public var backgroundView: UIView {
        return _backgroundView
    }
    
    ///
    /// Pan gesture interacting with dragging image view
    ///
    private var _panGestureRecognizer: UIPanGestureRecognizer!
    
    ///
    ///
    ///
    private var _shouldHideStatusBar = false
    
    ///
    ///
    ///
    private var _defaultStatusBarStyle = false
    
    ///
    ///
    ///
    private var animator = DTPhotoAnimator()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init?(referenceView: UIView?, image: UIImage?) {
        if let newImage = image, let view = referenceView {
            self.init()
            transitioningDelegate = self
            _referenceView = view
            _image = newImage
            
            //Calculate _originalFrame
            _originalFrame = view.superview!.convertRect(view.frame, toView: nil)
            
            modalPresentationStyle = UIModalPresentationStyle.Custom
            modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            modalPresentationCapturesStatusBarAppearance = false
        }
        else {
            return nil
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        //Background view
        _backgroundView = UIView(frame: self.view.bounds)
        view.addSubview(_backgroundView)
        _backgroundView.alpha = 0
        _backgroundView.backgroundColor = self.backgroundColor
        
        //Image view
        _imageView = UIImageView(frame: _originalFrame)
        _imageView.clipsToBounds = true
        _imageView.contentMode = _referenceView!.contentMode
        _imageView.clipsToBounds = _referenceView!.clipsToBounds
        _imageView.userInteractionEnabled = true
        _imageView.image = _image
        
        //Scroll view
        _scrollView = UIScrollView(frame: self.view.bounds)
        _scrollView.minimumZoomScale = 1.0
        _scrollView.maximumZoomScale = 5.0
        _scrollView.delegate = self
        _scrollView.addSubview(_imageView)
        view.addSubview(_scrollView)
        
        //Tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dynamicType._imageViewTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        //_imageView.addGestureRecognizer(tapGesture)
        
        //Double tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dynamicType._handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        _imageView.addGestureRecognizer(doubleTapGesture)
        
        //Pan gesture recognizer
        _panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dynamicType._handlePanGesture))
        _imageView.addGestureRecognizer(_panGestureRecognizer)
        
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !animated {
            self.presentingAnimation()
            self.presentingEnded()
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !animated {
            self.dismissingAnimation()
            self.dismissingEnded()
        }
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        if shouldHideStatusBarOnPresent {
            return _shouldHideStatusBar
        }
        return false
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if _defaultStatusBarStyle {
            return statusBarStyleOnPresenting
        }
        return statusBarStyleOnDismissing
    }
    
    private func startAnimation() {
        //Hide reference image view
        _referenceView?.hidden = true
        
        //Animate to center
        _animateToCenter()
    }
    
    func _animateToCenter() {
        UIView.animateWithDuration(animator.presentingDuration, animations: { 
            self.presentingAnimation()
            }) { (finished) in
                self.presentingEnded()
        }
    }
    
    func _dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func _imageViewTapped(gesture: UITapGestureRecognizer) {
        //Make status bar visible when beginning to drag image view
        _shouldHideStatusBar = false
        _defaultStatusBarStyle = false
        setNeedsStatusBarAppearanceUpdate()
        
        _dismiss()
    }
    
    func _handleDoubleTapGesture(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        if let center = gesture.view?.superview?.convertPoint(location, toView: _scrollView) {
            if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
                // Zoom out
                _scrollView.minimumZoomScale = 1.0
                _scrollView.setZoomScale(_scrollView.minimumZoomScale, animated: true)
                
            } else {
                // Zoom in
                _scrollView.minimumZoomScale = 1.0
                let rect = self.zoomRectForScrollView(_scrollView, withScale: _scrollView.maximumZoomScale, withCenter: center)
                _scrollView.zoomToRect(rect, animated: true)
            }
        }
    }
    
    func _handlePanGesture(gesture: UIPanGestureRecognizer) {
        if let view = gesture.view {
            switch gesture.state {
            case .Began:
                //Make status bar visible when beginning to drag image view
                _shouldHideStatusBar = false
                _defaultStatusBarStyle = false
                setNeedsStatusBarAppearanceUpdate()
                
            case .Changed:
                let translation = gesture.translationInView(view)
                self._imageView.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
                
                //Change opacity of background view based on vertical distance from center
                let yDistance = CGFloat(abs(self._imageView.center.y - self.view.center.y))
                let alpha = 1.0 - yDistance/(self.view.center.y)
                self._backgroundView.alpha = alpha
                
                //Scale image
                //Should not go smaller than max ratio
                if scaleWhileDragging {
                    let ratio = max(_originalFrame.size.height/_imageView.frame.height, _originalFrame.size.width/_imageView.frame.width)
                    
                    //If alpha = 0, then scale is max ratio, if alpha = 1, then scale is 1
                    let scale = 1 + (1 - alpha)*(ratio - 1)
                    _imageView.transform = CGAffineTransformMakeScale(scale, scale)
                }
                
            default:
                //Animate back to center
                if self._backgroundView.alpha < 0.8 {
                    _dismiss()
                }
                else {
                    _animateToCenter()
                }
            }
        }
    }
    
    public func presentingAnimation() {
        //Hide reference view
        _referenceView?.hidden = true
        
        //Calculate final frame
        let size = _image.size
        var destinationFrame = CGRectZero
        
        destinationFrame.size.width = view.frame.size.width
        destinationFrame.size.height = view.frame.size.width * (size.height / size.width)
        
        //Animate image view to the center
        self._imageView.frame = destinationFrame
        self._imageView.center = self.view.center
        
        //Change status bar to black style
        self._defaultStatusBarStyle = true
        self._shouldHideStatusBar = false
        self.setNeedsStatusBarAppearanceUpdate()
        
        //Animate background alpha
        self._backgroundView.alpha = 1.0
    }
    
    public func dismissingAnimation() {
        self._imageView.frame = self._originalFrame
        self._backgroundView.alpha = 0
    }
    
    public func presentingEnded() {
        self._shouldHideStatusBar = true
        self.setNeedsStatusBarAppearanceUpdate()
        UIView.animateWithDuration(0.2, animations: {
            
        })
    }
    
    public func dismissingEnded() {
        self._referenceView?.hidden = false
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension DTPhotoViewerController {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.type = .Presenting
        return animator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.type = .Dismissing
        return animator
    }
}


//MARK: - UIScrollViewDelegate
extension DTPhotoViewerController {
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        self.updateFrameFor(self.view.frame.size)
        
        //Disable pan gesture if zoom scale is not 1
        if scrollView.zoomScale != 1 {
            _panGestureRecognizer.enabled = false
        }
        else {
            _panGestureRecognizer.enabled = true
        }
    }
    
    private func _updateZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / _imageView.bounds.width
        let heightScale = size.height / _imageView.bounds.height
        let zoomScale = min(widthScale, heightScale)
        
        _scrollView.maximumZoomScale = zoomScale
    }
    
    private func zoomRectForScrollView(scrollView: UIScrollView, withScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRectZero
        
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
    
    private func updateFrameFor(size: CGSize) {
        
        let y = max(0, (size.height - _imageView.frame.height) / 2)
        let x = max(0, (size.width - _imageView.frame.width) / 2)
        
        _imageView.frame.origin = CGPoint(x: x, y: y)
    }
}
