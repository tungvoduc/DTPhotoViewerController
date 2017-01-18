//
//  DTPhotoViewerController+UISrcrollViewDelegate.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import Foundation

//MARK: - UICollectionViewDelegateFlowLayout
extension DTPhotoViewerController: UICollectionViewDelegateFlowLayout {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.photoViewerController?(self, scrollViewDidScroll: scrollView)
        setGestureRecognizers(false)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setGestureRecognizers(true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.updateFrameFor(self.view.frame.size)
        
        //Disable pan gesture if zoom scale is not 1
        if scrollView.zoomScale != 1 {
            panGestureRecognizer.isEnabled = false
        }
        else {
            panGestureRecognizer.isEnabled = true
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateImageView(scrollView: scrollView)
            setGestureRecognizers(true)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateImageView(scrollView: scrollView)
        setGestureRecognizers(true)
    }
    
    //MARK: Helpers
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
    
    // Update image view image
    func updateImageView(scrollView: UIScrollView) {
        let index = self.currentPhotoIndex
        
        // Update image view before pan gesture happens
        if let dataSource = dataSource {
            dataSource.photoViewerController(self, configurePhotoAt: index, withImageView: imageView)
        }
        
        // Call delegate
        delegate?.photoViewerController?(self, didScrollToItemAt: index)
        
        // Change referenced image view
        if let dataSource = dataSource {
            referencedView = dataSource.photoViewerController(self, referencedViewForPhotoAt: index)
        }
    }
    
    // Enable/diable gesture recoginzers
    private func setGestureRecognizers(_ enabled: Bool) {
        // doubleTapGestureRecognizer.isEnabled = enabled
        // singleTapGestureRecognizer.isEnabled = enabled
    }
}
