//
//  DTPhotoCollectionViewCell.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import UIKit

public protocol DTPhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidZoomOnPhoto(_ cell: DTPhotoCollectionViewCell, atScale scale: CGFloat)
    func collectionViewCellWillZoomOnPhoto(_ cell: DTPhotoCollectionViewCell)
    func collectionViewCellDidEndZoomingOnPhoto(_ cell: DTPhotoCollectionViewCell, atScale scale: CGFloat)
}

open class DTPhotoCollectionViewCell: UICollectionViewCell {
    public private(set) var scrollView: DTScrollView!
    public private(set) var imageView: UIImageView!
    
    // default is 1.0
    open var minimumZoomScale: CGFloat = 1.0 {
        willSet {
            if imageView.image == nil {
                scrollView.minimumZoomScale = 1.0
            } else {
                scrollView.minimumZoomScale = newValue
            }
        }
        
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    // default is 3.0.
    open var maximumZoomScale: CGFloat = 3.0 {
        willSet {
            if imageView.image == nil {
                scrollView.maximumZoomScale = 1.0
            } else {
                scrollView.maximumZoomScale = newValue
            }
        }
        
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    weak var delegate: DTPhotoCollectionViewCellDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        scrollView = DTScrollView(frame: CGRect.zero)
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = 1.0 // Not allow zooming when there is no image
        
        let imageView = DTImageView(frame: CGRect.zero)
        // Layout subviews every time getting new image
        imageView.imageChangeBlock = {[weak self](image: UIImage?) -> Void in
            // Update image frame whenever image changes
            if let strongSelf = self {
                if image == nil {
                    strongSelf.scrollView.minimumZoomScale = 1.0
                    strongSelf.scrollView.maximumZoomScale = 1.0
                } else {
                    strongSelf.scrollView.minimumZoomScale = strongSelf.minimumZoomScale
                    strongSelf.scrollView.maximumZoomScale = strongSelf.maximumZoomScale
                    strongSelf.setNeedsLayout()
                }
                strongSelf.correctCurrentZoomScaleIfNeeded()
            }
        }
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .automatic
        }
    }
    
    private func correctCurrentZoomScaleIfNeeded() {
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        scrollView.zoomScale = 1.0
        scrollView.frame = bounds
        
        //Set the aspect ration of the image
        if let image = imageView.image {
            let size = image.size
            let horizontalScale = size.width / scrollView.frame.width
            let verticalScale = size.height / scrollView.frame.height
            let factor = max(horizontalScale, verticalScale)
            
            //Divide the size by the greater of the vertical or horizontal shrinkage factor
            let width = size.width / factor
            let height = size.height / factor
            
            //Then figure out offset to center vertically or horizontally
            let x = (scrollView.frame.width - width) / 2
            let y = (scrollView.frame.height - height) / 2
            
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
}

//MARK: - UIScrollViewDelegate
extension DTPhotoCollectionViewCell: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.collectionViewCellWillZoomOnPhoto(self)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewFrameForSize(frame.size)
        
        delegate?.collectionViewCellDidZoomOnPhoto(self, atScale: scrollView.zoomScale)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.collectionViewCellDidEndZoomingOnPhoto(self, atScale: scale)
    }
    
    fileprivate func updateImageViewFrameForSize(_ size: CGSize) {
        
        let y = max(0, (size.height - imageView.frame.height) / 2)
        let x = max(0, (size.width - imageView.frame.width) / 2)
        
        imageView.frame.origin = CGPoint(x: x, y: y)
    }
}
