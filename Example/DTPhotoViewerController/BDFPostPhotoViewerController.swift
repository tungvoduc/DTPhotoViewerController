//
//  BDFPostPhotoViewerController.swift
//  DTPhotoViewerController
//
//  Created by Admin on 01/10/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import UIKit
import DTPhotoViewerController

class BDFPostPhotoViewerController: DTPhotoViewerController {
    var cancelButton: UIButton!
    
    override init?(referencedView: UIView?, image: UIImage?) {
        super.init(referencedView: referencedView, image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton = UIButton(type: UIButtonType.custom)
        cancelButton.setImage(UIImage.cancelIcon(size: CGSize(width: 15, height: 15), color: UIColor.white), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        cancelButton.isHidden = true
        
        self.view.addSubview(cancelButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cancelButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Hide & Show info layer view
    func reverseCancelButtonDisplayStatus() {
        if self.zoomScale == 1.0 {
            if cancelButton.isHidden == true {
                showCancelButton(animated: true)
            }
            else {
                hideCancelButton(animated: true)
            }
        }
    }
    
    func hideCancelButton(animated: Bool) {
        setCancelButtonHidden(true, animated: animated)
    }
    
    func showCancelButton(animated: Bool) {
        setCancelButtonHidden(false, animated: animated)
    }
    
    fileprivate func setCancelButtonHidden(_ hidden: Bool, animated: Bool) {
        if hidden != cancelButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            
            // Always unhide view before animation
            cancelButton.isHidden = false
            
            UIView.animate(withDuration: duration, animations: { 
                self.cancelButton.alpha = alpha
                }, completion: { (finished) in
                  self.cancelButton.isHidden = hidden
            })
        }
    }
}
