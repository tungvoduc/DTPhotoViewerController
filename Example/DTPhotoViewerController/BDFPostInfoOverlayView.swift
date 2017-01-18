//
//  BDFPostInfoOverlayView.swift
//  DTPhotoViewerController
//
//  Created by Admin on 01/10/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit

protocol BDFPostInfoOverlayViewDelegate: NSObjectProtocol {
    func postInfoOverlayViewDidTapLikeNumberButton(_ view: BDFPostInfoOverlayView, button: UIButton)
    func postInfoOverlayViewDidTapCommentNumberButton(_ view: BDFPostInfoOverlayView, button: UIButton)
    func postInfoOverlayViewDidTapLikeButton(_ view: BDFPostInfoOverlayView, button: UIButton)
    func postInfoOverlayViewDidTapMoreButton(_ view: BDFPostInfoOverlayView, button: UIButton)
    func postInfoOverlayViewDidTapCancelButton(_ view: BDFPostInfoOverlayView, button: UIButton)
}

private var kIconSize: CGFloat { return 15 }
private var kButtonTitleLeftInset: CGFloat { return 5 }

class BDFPostInfoOverlayView: UIView {
    weak var delegate: BDFPostInfoOverlayViewDelegate?
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeNumberButton: UIButton!
    @IBOutlet weak var commentNumberButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var likeNumberButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentNumberButtonWidthConstraint: NSLayoutConstraint!
    
    class func initiateFromNib() -> BDFPostInfoOverlayView {
        let nib = UINib(nibName: "BDFPostInfoOverlayView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BDFPostInfoOverlayView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
        likeButton.setImage(UIImage.likeIconLine(size: CGSize(width: 30, height: 30), color: UIColor.white), for: UIControlState())
        likeButton.setImage(UIImage.likeIconSolid(size: CGSize(width: 30, height: 30), color: UIColor.red), for: .selected)
        likeButton.setTitle(nil, for: UIControlState())
        
        commentNumberButton.setImage(UIImage.commentIcon(size: CGSize(width: kIconSize, height: kIconSize), color: UIColor.white), for: UIControlState())
        commentNumberButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        commentNumberButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: kButtonTitleLeftInset, bottom: 0, right: 0)
        commentNumberButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        moreButton.setImage(UIImage.moreIcon(size: CGSize(width: 25, height: 5), color: UIColor.white), for: UIControlState())
        moreButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        cancelButton.setImage(UIImage.cancelIcon(size: CGSize(width: 15, height: 15), color: UIColor.white), for: UIControlState())
        
        likeNumberButton.setImage(UIImage.likeIconSolid(size: CGSize(width: kIconSize, height: kIconSize), color: UIColor.white), for: UIControlState())
        likeNumberButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        likeNumberButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: kButtonTitleLeftInset, bottom: 0, right: 0)
        likeNumberButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    }
    
    func setNumberOfLikes(_ number: Int) {
        let title = "\(number)"
        likeNumberButton.setTitle(title, for: UIControlState())
        likeNumberButtonWidthConstraint.constant = kIconSize + kButtonTitleLeftInset + 30 + kButtonTitleLeftInset
    }
    
    func setNumberOfComments(_ number: Int) {
        let title = "\(number)"
        commentNumberButton.setTitle(title, for: UIControlState())
        commentNumberButtonWidthConstraint.constant = kIconSize + kButtonTitleLeftInset + 150 + kButtonTitleLeftInset
    }
    
    func setLiked(_ liked: Bool) {
        likeButton.isSelected = liked
    }

    @IBAction func likeNumberButtonTapped(_ button: UIButton) {
        delegate?.postInfoOverlayViewDidTapLikeNumberButton(self, button: likeNumberButton)
    }
    
    
    @IBAction func commentNumberButtonTapped(_ button: UIButton) {
        delegate?.postInfoOverlayViewDidTapCommentNumberButton(self, button: commentNumberButton)
    }
    
    @IBAction func likeButtonTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (finished) in
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (finished) in
                    
                }
            }
        }
        
        delegate?.postInfoOverlayViewDidTapLikeButton(self, button: likeButton)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        delegate?.postInfoOverlayViewDidTapMoreButton(self, button: moreButton)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.postInfoOverlayViewDidTapCancelButton(self, button: cancelButton)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
