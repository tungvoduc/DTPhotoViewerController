//
//  DTPhotoViewerControllerDelegate.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import UIKit

@objc public protocol DTPhotoViewerControllerDelegate: NSObjectProtocol {
    @objc optional func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToItemAt index: Int)
    
    @objc optional func photoViewerController(_ photoViewerController: DTPhotoViewerController, didZoomOnImageAtIndex: Int, withZoomScale zoomScale: CGFloat)
    
    @objc optional func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: DTPhotoViewerController)
    
    @objc optional func photoViewerControllerDidReceiveDoubleTapGesture(_ photoViewerController: DTPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: DTPhotoViewerController, willBeginPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerController(_ photoViewerController: DTPhotoViewerController, didEndPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: DTPhotoViewerController, scrollViewDidScroll: UIScrollView)
}
