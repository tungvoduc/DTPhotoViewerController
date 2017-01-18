//
//  DTImageView.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import UIKit

class DTImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var image: UIImage? {
        didSet {
            imageChangeBlock?(image)
        }
    }
    
    var imageChangeBlock: ((UIImage?) -> Void)?
}
