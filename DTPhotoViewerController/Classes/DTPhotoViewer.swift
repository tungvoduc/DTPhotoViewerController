//
//  DTPhotoViewer.swift
//  DTPhotoViewerController
//
//  Created by Vo Duc Tung on 04/05/16.
//  Copyright © 2016 Vo Duc Tung. All rights reserved.
//

import Foundation

public protocol DTPhotoViewer: class {
    var imageView: UIImageView {get}
    weak var referenceView: UIView? {get}
    var backgroundView: UIView {get}
    var originalFrame: CGRect {get}
    var backgroundColor: UIColor {get set}
    var image: UIImage {get}
    func presentingAnimation()
    func dismissingAnimation()
    
    func presentingEnded()
    func dismissingEnded()
}