//
//  DTPhotoViewerController.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 29/04/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit

private let kPhotoCollectionViewCellIdentifier = "Cell"

open class DTPhotoViewerController: UIViewController {
    
    /// Datasource
    /// Providing number of image items to controller and how to confiure image for each image view in it.
    public var dataSource: DTPhotoViewerControllerDataSource?
    
    /// Delegate
    public var delegate: DTPhotoViewerControllerDelegate?
    
    /// Indicates if status bar should be hidden after photo viewer controller is presented.
    /// Default value is true
    open var shouldHideStatusBarOnPresent = true
    
    /// Indicates status bar style when photo viewer controller is being presenting
    /// Default value if UIStatusBarStyle.default
    open var statusBarStyleOnPresenting: UIStatusBarStyle = UIStatusBarStyle.default
    
    /// Indicates status bar animation style when changing hidden status
    /// Default value if UIStatusBarStyle.fade
    open var statusBarAnimationStyle: UIStatusBarAnimation = UIStatusBarAnimation.fade
    
    /// Indicates status bar style after photo viewer controller is being dismissing
    /// Include when pan gesture recognizer is active.
    /// Default value if UIStatusBarStyle.LightContent
    open var statusBarStyleOnDismissing: UIStatusBarStyle = UIStatusBarStyle.lightContent
    
    /// Background color of the viewer.
    /// Default value is black.
    open var backgroundColor: UIColor = UIColor.black {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
    /// Indicates where image should be scaled smaller when being dragged.
    /// Default value is true.
    open var scaleWhileDragging = true
    
    /// This variable sets original frame of image view to animate from
    open fileprivate(set) var referenceSize: CGSize = CGSize.zero
    
    
    /// Presenting size
    /// The final size after image View is presented.
    fileprivate var _presentedImageViewSize: CGSize = CGSize.zero
    
    
    /// This is the image view that is mainly used for the presentation and dismissal effect.
    /// How it animate from the original view to fullscreen and vice versa.
    open fileprivate(set) var imageView: UIImageView
    
    /// The view where photo viewer origibally animates from.
    /// Provide this correctly so that you can have a nice effect.
    weak internal(set) open var referencedView: UIView? {
        didSet {
            // Unhide old referenced view and hide the new one
            oldValue?.isHidden = false
            referencedView?.isHidden = true
        }
    }
    
    /// Collection view.
    /// This will be used when displaying multiple images.
    fileprivate(set) var collectionView: UICollectionView
    open var scrollView: UIScrollView {
        return collectionView
    }
    
    /// View that has fading effect during presentation and dismissal animation or when controller is being dragged.
    open fileprivate(set) var backgroundView: UIView
    
    /// Pan gesture for dragging controller
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// Double tap gesture
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    /// Single tap gesture
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    fileprivate var _shouldHideStatusBar = false
    fileprivate var _defaultStatusBarStyle = false
    
    /// Transition animator
    /// Customizable if you wish to provide your own transitions.
    open lazy var animator: DTPhotoViewerBaseAnimator = DTPhotoAnimator()
    
    public init?(referencedView: UIView?, image: UIImage?) {
        if let newImage = image {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets.zero
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            // Collection view
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            collectionView.register(DTPhotoCollectionViewCell.self, forCellWithReuseIdentifier: kPhotoCollectionViewCellIdentifier)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isPagingEnabled = true
            
            backgroundView = UIView(frame: CGRect.zero)
            
            // Image view
            let newImageView = DTImageView(frame: CGRect.zero)
            imageView = newImageView
            
            super.init(nibName: nil, bundle: nil)
            
            transitioningDelegate = self
            
            imageView.image = newImage
            self.referencedView = referencedView
            collectionView.dataSource = self
            
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
        if let view = referencedView {
            // Content mode should be identical between image view and reference view
            imageView.contentMode = view.contentMode
        }
        
        //Background view
        view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = self.backgroundColor
        
        //Image view
        // Configure this block for changing image size when image changed
        (imageView as? DTImageView)?.imageChangeBlock = {[weak self](image: UIImage?) -> Void in
            // Update image frame whenever image changes
            if let strongSelf = self, let image = image {
                strongSelf._presentedImageViewSize = strongSelf.imageViewSizeForImage(image: image)
                strongSelf.imageView.frame.size = strongSelf._presentedImageViewSize
                strongSelf.imageView.center = strongSelf.view.center
                
                // No datasource, only 1 item in collection view --> reloadData
                guard let _ = strongSelf.dataSource else {
                    strongSelf.collectionView.reloadData()
                    return
                }
            }
        }
        
        imageView.frame = _frameForReferencedView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        //Scroll view
        scrollView.delegate = self
        view.addSubview(imageView)
        view.addSubview(scrollView)
        
        //Tap gesture recognizer
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(_handleTapGesture))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        
        //Pan gesture recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(_handlePanGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.view.isUserInteractionEnabled = true
        
        //Double tap gesture recognizer
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(_handleDoubleTapGesture))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
        
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
            self.presentationAnimationDidFinish()
        }
        else {
            self.presentationAnimationWillStart()
            
            if let referencedView = referencedView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = referencedView.layer.cornerRadius
                animation.toValue = 0
                animation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "cornerRadius")
                imageView.layer.cornerRadius = 0
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderColorAnimation.fromValue = referencedView.layer.borderColor
                borderColorAnimation.toValue = UIColor.clear.cgColor
                borderColorAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderColor")
                imageView.layer.borderColor = UIColor.clear.cgColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderWidthAnimation.fromValue = referencedView.layer.borderWidth
                borderWidthAnimation.toValue = 0
                borderWidthAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderWidth")
                imageView.layer.borderWidth = referencedView.layer.borderWidth
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !animated {
            self.dismissingAnimation()
            self.dismissalAnimationDidFinish()
        }
        else {
            self.dismissalAnimationWillStart()
            
            if let referencedView = referencedView {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = 0
                animation.toValue = referencedView.layer.cornerRadius
                animation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "cornerRadius")
                imageView.layer.cornerRadius = referencedView.layer.cornerRadius
                
                // Border color
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderColorAnimation.fromValue = UIColor.clear.cgColor
                borderColorAnimation.toValue = referencedView.layer.borderColor
                borderColorAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderColor")
                imageView.layer.borderColor = referencedView.layer.borderColor
                
                // Border width
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                borderWidthAnimation.fromValue = 0
                borderWidthAnimation.toValue = referencedView.layer.borderWidth
                borderWidthAnimation.duration = animator.presentingDuration
                imageView.layer.add(animation, forKey: "borderWidth")
                imageView.layer.borderWidth = referencedView.layer.borderWidth
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
    
    //MARK: Private methods
    fileprivate func startAnimation() {
        //Hide reference image view
        referencedView?.isHidden = true
        
        //Animate to center
        _animateToCenter()
    }
    
    func _animateToCenter() {
        UIView.animate(withDuration: animator.presentingDuration, animations: {
            self.presentingAnimation()
        }) { (finished) in
            // Presenting animation ended
            self.presentationAnimationDidFinish()
        }
    }
    
    func _hideImageView(_ imageViewHidden: Bool) {
        // Hide image view should show collection view and vice versa
        imageView.isHidden = imageViewHidden
        scrollView.isHidden = !imageViewHidden
    }
    
    func _dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Delegate method
        delegate?.photoViewerControllerDidReceiveTapGesture?(self)
    }
    
    func _handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Delegate method
        delegate?.photoViewerControllerDidReceiveDoubleTapGesture?(self)
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DTPhotoCollectionViewCell {
            let location = gesture.location(in: cell.imageView)
            
            if let center = gesture.view?.superview?.convert(location, to: cell.scrollView) {
                // Double tap
                // self.imageViewerControllerDidDoubleTapImageView()
                
                if (cell.scrollView.zoomScale == cell.scrollView.maximumZoomScale) {
                    // Zoom out
                    cell.scrollView.minimumZoomScale = 1.0
                    cell.scrollView.setZoomScale(cell.scrollView.minimumZoomScale, animated: true)
                    
                } else {
                    // Zoom in
                    cell.scrollView.minimumZoomScale = 1.0
                    let rect = zoomRectForScrollView(cell.scrollView, withScale: cell.scrollView.maximumZoomScale, withCenter: center)
                    cell.scrollView.zoom(to: rect, animated: true)
                }
            }
        }
    }
    
    func _frameForReferencedView() -> CGRect {
        if let view = referencedView {
            if let superview = view.superview {
                var frame = (superview.convert(view.frame, to: self.view))
                referenceSize = frame.size
                
                if abs(frame.size.width - view.frame.size.width) > 1 {
                    // This is workaround for bug in ios 8, everything is double.
                    frame = CGRect(x: frame.origin.x/2, y: frame.origin.y/2, width: frame.size.width/2, height: frame.size.height/2)
                    referenceSize = frame.size
                }
                
                return frame
            }
        }
        
        // Work around when there is no reference view, dragging might behave oddly
        // Should be fixed in the future
        let defaultSize: CGFloat = 1
        referenceSize = CGSize(width: defaultSize, height: defaultSize)
        return CGRect(x: self.view.frame.midX - defaultSize/2, y: self.view.frame.midY - defaultSize/2, width: defaultSize, height: defaultSize)
    }
    
    // Update zoom inside UICollectionViewCell
    fileprivate func _updateZoomScaleForSize(cell: DTPhotoCollectionViewCell, size: CGSize) {
        let widthScale = size.width / cell.imageView.bounds.width
        let heightScale = size.height / cell.imageView.bounds.height
        let zoomScale = min(widthScale, heightScale)
        
        cell.scrollView.maximumZoomScale = zoomScale
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
    
    func _handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if let view = gesture.view {
            switch gesture.state {
            case .began:
                //Make status bar visible when beginning to drag image view
                _shouldHideStatusBar = false
                _defaultStatusBarStyle = false
                
                setNeedsStatusBarAppearanceUpdate()
                
                // Hide collection view & display image view
                _hideImageView(false)
                
                // Delegate method
                delegate?.photoViewerController?(self, willBeginPanGestureRecognizer: panGestureRecognizer)
                
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
                    let ratio = max(referenceSize.height/imageView.frame.height, referenceSize.width/imageView.frame.width)
                    
                    //If alpha = 0, then scale is max ratio, if alpha = 1, then scale is 1
                    let scale = 1 + (1 - alpha)*(ratio - 1)
                    
                    //imageView.transform = CGAffineTransformMakeScale(scale, scale)
                    // Do not use transform to scale down image view
                    // Instead change width & height
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
                
                // Delegate method
                delegate?.photoViewerController?(self, didEndPanGestureRecognizer: panGestureRecognizer)
            }
        }
    }
    
    private func imageViewSizeForImage(image: UIImage?) -> CGSize {
        if let image = image {
            let size = image.size
            var destinationSize = CGSize.zero
            
            // Calculate size of image view so that it would fit in self.view
            // This will make the transition more perfect than setting frame of UIImageView as self.view.bounds
            if image.size.width/image.size.height > view.frame.size.width/view.frame.size.height {
                destinationSize.width = view.frame.size.width
                destinationSize.height = view.frame.size.width * (size.height / size.width)
            }
            else {
                destinationSize.height = view.frame.size.height
                destinationSize.width = view.frame.size.height * (size.width / size.height)
            }
            
            print("\(destinationSize)\n")
            
            return destinationSize
        }
        
        return CGSize.zero
    }
    
    func presentingAnimation() {
        //Hide reference view
        referencedView?.isHidden = true
        
        //Calculate final frame
        var destinationFrame = CGRect.zero
        destinationFrame.size = imageViewSizeForImage(image: imageView.image)
        
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
    
    func dismissingAnimation() {
        self.imageView.frame = _frameForReferencedView()
        self.backgroundView.alpha = 0
    }
    
    func presentationAnimationDidFinish() {
        // Delegate method
        self.delegate?.photoViewerControllerDidEndPresentingAnimation?(self)
        
        // Hide animating image view and show collection view
        _hideImageView(true)
    }
    
    func presentationAnimationWillStart() {
        // Hide collection view and show image view
        _hideImageView(false)
    }
    
    func dismissalAnimationWillStart() {
        // Hide collection view and show image view
        _hideImageView(false)
    }
    
    func dismissalAnimationDidFinish() {
        referencedView?.isHidden = false
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

//MARK: UICollectionViewDataSource
extension DTPhotoViewerController: UICollectionViewDataSource {
    //MARK: Public methods
    public var currentPhotoIndex: Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    public var currentPhotoZoomScale: CGFloat {
        let index = currentPhotoIndex
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DTPhotoCollectionViewCell {
            return cell.scrollView.zoomScale
        }
        
        return 1.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCollectionViewCellIdentifier, for: indexPath) as!DTPhotoCollectionViewCell
        cell.delegate = self
        
        if let dataSource = dataSource {
            dataSource.photoViewerController(self, configurePhotoAt: indexPath.row, withImageView: cell.imageView)
        }
        else {
            cell.imageView.image = imageView.image
        }
        
        return cell
    }
}

//MARK: Public data methods
extension DTPhotoViewerController {
    // Update data before calling theses methods
    open func reloadData() {
        collectionView.reloadData()
    }
    
    open func insertPhotos(at indexes: [Int], completion: ((Bool) -> Void)?) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.performBatchUpdates({ 
            self.collectionView.insertItems(at: indexPaths)
        }, completion: completion)
    }
    
    open func deletePhotos(at indexes: [Int], completion: ((Bool) -> Void)?) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: indexPaths)
        }, completion: completion)
    }
    
    open func reloadPhotos(at indexes: [Int]) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.reloadItems(at: indexPaths)
    }
    
    open func movePhoto(at index: Int, to newIndex: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let newIndexPath = IndexPath(item: newIndex, section: 0)
        
        collectionView.moveItem(at: indexPath, to: newIndexPath)
    }
    
    open func scrollToPhoto(at index: Int, animated: Bool) {
        if self.collectionView.numberOfItems(inSection: 0) > index {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: animated)
        }
    }
    
    // Helper for indexpaths
    func indexPathsForIndexes(indexes: [Int]) -> [IndexPath] {
        return indexes.map() {
            IndexPath(item: $0, section: 0)
        }
    }
}

//MARK: DTPhotoCollectionViewCellDelegate
extension DTPhotoViewerController: DTPhotoCollectionViewCellDelegate {
    public func collectionViewCellDidZoomOnImage(_ cell: DTPhotoCollectionViewCell, zoomScale: CGFloat) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // Call delegate
            delegate?.photoViewerController?(self, didZoomOnImageAtIndex: indexPath.row, withZoomScale: zoomScale)
        }
    }
}
