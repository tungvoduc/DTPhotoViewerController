//
//  BDFSimplePhotoViewerController.swift
//  DTPhotoViewerController
//
//  Created by Admin on 01/10/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit
import DTPhotoViewerController

private var kElementHorizontalMargin: CGFloat  { return 20 }
private var kElementHeight: CGFloat { return 40 }
private var kElementWidth: CGFloat  { return 50 }
private var kElementBottomMargin: CGFloat  { return 10 }

protocol BDFSimplePhotoViewerControllerDelegate: DTPhotoViewerControllerDelegate {
    func simplePhotoViewerController(_ viewController: BDFSimplePhotoViewerController, savePhotoAt index: Int)
}

class BDFSimplePhotoViewerController: DTPhotoViewerController {
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(frame: CGRect.zero)
        cancelButton.setImage(UIImage.cancelIcon(size: CGSize(width: 15, height: 15), color: UIColor.white), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return cancelButton
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(frame: CGRect.zero)
        moreButton.setImage(UIImage.moreIcon(size: CGSize(width: 16, height: 16), color: UIColor.white), for: UIControlState())
        moreButton.contentHorizontalAlignment = .right
        moreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kElementHorizontalMargin)
        moreButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        return moreButton
    }()
    
    deinit {
        print("BDFSimplePhotoViewerController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerClassPhotoViewer(CustomPhotoCollectionViewCell.self)
        view.addSubview(cancelButton)
        view.addSubview(moreButton)
        
        configureOverlayViews(hidden: true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let y = bottomButtonsVerticalPosition()
        
        // Layout subviews
        let buttonHeight: CGFloat = kElementHeight
        let buttonWidth: CGFloat = kElementWidth
        
        cancelButton.frame = CGRect(origin: CGPoint(x: 20, y: 0), size: CGSize(width: buttonWidth, height: buttonHeight))
        moreButton.frame = CGRect(origin: CGPoint(x: view.bounds.width - buttonWidth, y: y), size: CGSize(width: buttonWidth, height: kElementHeight))
    }
    
    func bottomButtonsVerticalPosition() -> CGFloat {
        return view.bounds.height - kElementHeight - kElementBottomMargin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        let saveButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (_) in
            // Save photo to Camera roll
            if let delegate = self.delegate as? BDFSimplePhotoViewerControllerDelegate {
                delegate.simplePhotoViewerController(self, savePhotoAt: self.currentPhotoIndex)
            }
        }
        alertController.addAction(saveButton)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func cancelButtonTapped(_ sender: UIButton) {
        hideInfoOverlayView(false)
        dismiss(animated: true, completion: nil)
    }
    
    func hideInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: true, animated: animated)
    }
    
    func showInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: false, animated: animated)
    }
    
    func configureOverlayViews(hidden: Bool, animated: Bool) {
        if hidden != cancelButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            
            // Always unhide view before animation
            setOverlayElementsHidden(isHidden: false)
            
            UIView.animate(withDuration: duration, animations: {
                self.setOverlayElementsAlpha(alpha: alpha)
                
            }, completion: { (finished) in
                self.setOverlayElementsHidden(isHidden: hidden)
            })
        }
    }
    
    func setOverlayElementsHidden(isHidden: Bool) {
        cancelButton.isHidden = isHidden
        moreButton.isHidden = isHidden
    }
    
    func setOverlayElementsAlpha(alpha: CGFloat) {
        moreButton.alpha = alpha
        cancelButton.alpha = alpha
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

/// These methods should not be overridden
/// If they are overridden, super should always be called for correct implementation.
extension BDFSimplePhotoViewerController {
    override func didReceiveTapGesture() {
        reverseInfoOverlayViewDisplayStatus()
    }
    
    override func willZoomOnPhoto(at index: Int) {
        hideInfoOverlayView(false)
    }
    
    override func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
        if scale == 1 {
            showInfoOverlayView(true)
        }
    }
    
    override func didEndPresentingAnimation() {
        showInfoOverlayView(true)
    }
    
    override func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        hideInfoOverlayView(false)
    }
    
    override func didReceiveDoubleTapGesture() {
        hideInfoOverlayView(false)
    }
    
    // Hide & Show info layer view
    func reverseInfoOverlayViewDisplayStatus() {
        if zoomScale == 1.0 {
            if cancelButton.isHidden == true {
                showInfoOverlayView(true)
            }
            else {
                hideInfoOverlayView(true)
            }
        }
    }
}

class CustomPhotoCollectionViewCell: DTPhotoCollectionViewCell {
    lazy var extraLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(extraLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = 70
        extraLabel.frame = CGRect(x: self.bounds.size.width - width - 20, y: 0, width: width, height: 60)
    }
}
