//
//  DTPhotoCollectionViewCell.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import UIKit

public protocol DTPhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidZoomOnImage(_ cell: DTPhotoCollectionViewCell, zoomScale: CGFloat)
}

public class DTPhotoCollectionViewCell: UICollectionViewCell {
    public private(set) var scrollView: DTScrollView!
    public private(set) var imageView: UIImageView!
    
    var delegate: DTPhotoCollectionViewCellDelegate?
    
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
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        imageView.frame = self.bounds
    }
}

//MARK: - UIScrollViewDelegate
extension DTPhotoCollectionViewCell: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.updateImageViewFrameForSize(self.frame.size)
        
        delegate?.collectionViewCellDidZoomOnImage(self, zoomScale: scrollView.zoomScale)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    fileprivate func updateImageViewFrameForSize(_ size: CGSize) {
        
        let y = max(0, (size.height - imageView.frame.height) / 2)
        let x = max(0, (size.width - imageView.frame.width) / 2)
        
        imageView.frame.origin = CGPoint(x: x, y: y)
    }
}
