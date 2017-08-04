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
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        let imageView = DTImageView(frame: CGRect.zero)
        // Layout subviews every time getting new image
        imageView.imageChangeBlock = {[weak self](image: UIImage?) -> Void in
            // Update image frame whenever image changes
            if let strongSelf = self, let _ = image {
                strongSelf.setNeedsLayout()
            }
        }
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        
        //Set the aspect ration of the image
        if let image = imageView.image {
            let size = image.size
            let horizontalScale = size.width / self.bounds.width
            let verticalScale = size.height / self.bounds.height
            let factor = max(horizontalScale, verticalScale)
            
            //Divide the size by the greater of the vertical or horizontal shrinkage factor
            let width = size.width / factor
            let height = size.height / factor
            
            //Then figure out offset to center vertically or horizontally
            let x = (self.bounds.width - width) / 2
            let y = (self.bounds.height - height) / 2
            
            self.imageView.frame = CGRect(x: x, y: y, width: width, height: height)
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
        self.updateImageViewFrameForSize(self.frame.size)
        
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
