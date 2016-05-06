//
//  ViewController.swift
//  DTPhotoViewerController
//
//  Created by Tung Vo on 05/07/2016.
//  Copyright (c) 2016 Tung Vo. All rights reserved.
//

import UIKit
import DTPhotoViewerController

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dynamicType.imageViewTapped(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageViewTapped(gesture: UITapGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            guard let image = imageView.image else {
                return
            }
            
            if let viewController = DTPhotoViewerController(referenceView: imageView, image: image) {
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        }
    }
}

