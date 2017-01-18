//
//  UIImage.swift
//  DTPhotoViewerController
//
//  Created by Admin on 18/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {
    public class func likeIconSolid(size: CGSize, color fillColor: UIColor!) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        //PaintCode here
        //// Subframes
        let subframe: CGRect = CGRect(x: frame.minX + floor(frame.width * 0.01000 + 0.32) + 0.18, y: frame.minY + floor(frame.height * 0.04333 - 0.28) + 0.78, width: floor(frame.width * 0.99000 - 0.32) - floor(frame.width * 0.01000 + 0.32) + 0.64, height: floor(frame.height * 0.95667 + 0.28) - floor(frame.height * 0.04333 - 0.28) - 0.56)
        
        
        //// subframe
        //// Group 2
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: subframe.minX + 1.00000 * subframe.width, y: subframe.minY + 0.29015 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 0.51814 * subframe.width, y: subframe.minY + 0.99148 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 1.00000 * subframe.width, y: subframe.minY + 0.48540 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.75283 * subframe.width, y: subframe.minY + 0.83698 * subframe.height))
        bezierPath.addLine(to: CGPoint(x: subframe.minX + 0.50000 * subframe.width, y: subframe.minY + 1.00000 * subframe.height))
        bezierPath.addLine(to: CGPoint(x: subframe.minX + 0.48186 * subframe.width, y: subframe.minY + 0.99148 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 0.00000 * subframe.width, y: subframe.minY + 0.29015 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 0.24717 * subframe.width, y: subframe.minY + 0.83698 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.00000 * subframe.width, y: subframe.minY + 0.48540 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 0.27268 * subframe.width, y: subframe.minY + -0.00000 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 0.00057 * subframe.width, y: subframe.minY + 0.13017 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.12302 * subframe.width, y: subframe.minY + -0.00000 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 0.50000 * subframe.width, y: subframe.minY + 0.13078 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 0.36735 * subframe.width, y: subframe.minY + -0.00000 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.45125 * subframe.width, y: subframe.minY + 0.05231 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 0.72732 * subframe.width, y: subframe.minY + -0.00000 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 0.54875 * subframe.width, y: subframe.minY + 0.05231 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.63265 * subframe.width, y: subframe.minY + -0.00000 * subframe.height))
        bezierPath.addCurve(to: CGPoint(x: subframe.minX + 1.00000 * subframe.width, y: subframe.minY + 0.29015 * subframe.height), controlPoint1: CGPoint(x: subframe.minX + 0.87698 * subframe.width, y: subframe.minY + -0.00000 * subframe.height), controlPoint2: CGPoint(x: subframe.minX + 0.99943 * subframe.width, y: subframe.minY + 0.13017 * subframe.height))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public class func likeIconLine(size: CGSize, color fillColor: UIColor!) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        //PaintCode here
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.51789 * frame.width, y: frame.minY + 0.94856 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.49994 * frame.width, y: frame.minY + 0.95644 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.48206 * frame.width, y: frame.minY + 0.94856 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.01000 * frame.width, y: frame.minY + 0.30794 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.25189 * frame.width, y: frame.minY + 0.80750 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.01000 * frame.width, y: frame.minY + 0.48633 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.27728 * frame.width, y: frame.minY + 0.04333 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.01078 * frame.width, y: frame.minY + 0.16189 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.13039 * frame.width, y: frame.minY + 0.04333 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.16250 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.37011 * frame.width, y: frame.minY + 0.04333 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.45206 * frame.width, y: frame.minY + 0.09072 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.72272 * frame.width, y: frame.minY + 0.04333 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.54789 * frame.width, y: frame.minY + 0.09072 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.62989 * frame.width, y: frame.minY + 0.04333 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.99006 * frame.width, y: frame.minY + 0.30794 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.86967 * frame.width, y: frame.minY + 0.04333 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.98922 * frame.width, y: frame.minY + 0.16189 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.51789 * frame.width, y: frame.minY + 0.94856 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.98994 * frame.width, y: frame.minY + 0.48633 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.74800 * frame.width, y: frame.minY + 0.80750 * frame.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.72267 * frame.width, y: frame.minY + 0.08772 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.53706 * frame.width, y: frame.minY + 0.18706 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.64794 * frame.width, y: frame.minY + 0.08772 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.57861 * frame.width, y: frame.minY + 0.12483 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.49994 * frame.width, y: frame.minY + 0.24256 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.46289 * frame.width, y: frame.minY + 0.18700 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.27728 * frame.width, y: frame.minY + 0.08767 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.42133 * frame.width, y: frame.minY + 0.12478 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.35194 * frame.width, y: frame.minY + 0.08767 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.05456 * frame.width, y: frame.minY + 0.30794 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.15517 * frame.width, y: frame.minY + 0.08767 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.05522 * frame.width, y: frame.minY + 0.18661 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.90744 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.05456 * frame.width, y: frame.minY + 0.46528 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.28250 * frame.width, y: frame.minY + 0.77133 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.94544 * frame.width, y: frame.minY + 0.30822 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.71750 * frame.width, y: frame.minY + 0.77139 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.94544 * frame.width, y: frame.minY + 0.46533 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.72267 * frame.width, y: frame.minY + 0.08772 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.94472 * frame.width, y: frame.minY + 0.18661 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.84478 * frame.width, y: frame.minY + 0.08772 * frame.height))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //Size 1 x 1
    public class func commentIcon(size: CGSize, color fillColor: UIColor!) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        //PaintCode here
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.85714 * frame.width, y: frame.minY + 0.00000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.14286 * frame.width, y: frame.minY + 0.00000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.14286 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.06429 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.06429 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.64286 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.14286 * frame.width, y: frame.minY + 0.78571 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.72143 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.06429 * frame.width, y: frame.minY + 0.78571 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.21429 * frame.width, y: frame.minY + 0.78571 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.21429 * frame.width, y: frame.minY + 0.92857 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.28571 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.21429 * frame.width, y: frame.minY + 0.97543 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.25500 * frame.width, y: frame.minY + 1.00000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.35714 * frame.width, y: frame.minY + 0.96314 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.31086 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.32479 * frame.width, y: frame.minY + 0.99164 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.57143 * frame.width, y: frame.minY + 0.78571 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.85714 * frame.width, y: frame.minY + 0.78571 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.64286 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.93571 * frame.width, y: frame.minY + 0.78571 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.72143 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.14286 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.85714 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.06429 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.93571 * frame.width, y: frame.minY + 0.00000 * frame.height))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //More action icon 320x64
    public class func moreIcon(size: CGSize, color fillColor: UIColor!) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        //PaintCode here
        //// frame
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + floor(frame.width * 0.39925 - 0.1) + 0.6, y: frame.minY + floor(frame.height * 0.00000 + 0.5), width: floor(frame.width * 0.59950 - 0.1) - floor(frame.width * 0.39925 - 0.1), height: floor(frame.height * 1.00000 + 0.5) - floor(frame.height * 0.00000 + 0.5)))
        fillColor.setFill()
        ovalPath.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + floor(frame.width * 0.00000 + 0.5), y: frame.minY + floor(frame.height * 0.00000 + 0.5), width: floor(frame.width * 0.20025 + 0.5) - floor(frame.width * 0.00000 + 0.5), height: floor(frame.height * 1.00000 + 0.5) - floor(frame.height * 0.00000 + 0.5)))
        fillColor.setFill()
        oval2Path.fill()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + floor(frame.width * 0.79975 - 0.1) + 0.6, y: frame.minY + floor(frame.height * 0.00000 + 0.5), width: floor(frame.width * 1.00000 - 0.1) - floor(frame.width * 0.79975 - 0.1), height: floor(frame.height * 1.00000 + 0.5) - floor(frame.height * 0.00000 + 0.5)))
        fillColor.setFill()
        oval3Path.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //size 13x13
    public class func cancelIcon(size: CGSize, color fillColor : UIColor!) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        let bounds: CGRect = frame
        
        //// cross Drawing
        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: bounds.minX + 0.97466 * bounds.width, y: bounds.minY + 0.85227 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.97466 * bounds.width, y: bounds.minY + 0.97465 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 1.00845 * bounds.width, y: bounds.minY + 0.88606 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 1.00845 * bounds.width, y: bounds.minY + 0.94087 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.91347 * bounds.width, y: bounds.minY + 1.00000 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.95775 * bounds.width, y: bounds.minY + 0.99156 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.93562 * bounds.width, y: bounds.minY + 1.00000 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.85227 * bounds.width, y: bounds.minY + 0.97465 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.89131 * bounds.width, y: bounds.minY + 1.00000 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.86918 * bounds.width, y: bounds.minY + 0.99156 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.50000 * bounds.width, y: bounds.minY + 0.62238 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.14773 * bounds.width, y: bounds.minY + 0.97465 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.08653 * bounds.width, y: bounds.minY + 1.00000 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.13082 * bounds.width, y: bounds.minY + 0.99156 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.10869 * bounds.width, y: bounds.minY + 1.00000 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.02534 * bounds.width, y: bounds.minY + 0.97465 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.06438 * bounds.width, y: bounds.minY + 1.00000 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.04225 * bounds.width, y: bounds.minY + 0.99156 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.02534 * bounds.width, y: bounds.minY + 0.85227 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + -0.00845 * bounds.width, y: bounds.minY + 0.94087 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + -0.00845 * bounds.width, y: bounds.minY + 0.88606 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.37761 * bounds.width, y: bounds.minY + 0.50000 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.02534 * bounds.width, y: bounds.minY + 0.14773 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.02534 * bounds.width, y: bounds.minY + 0.02534 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + -0.00845 * bounds.width, y: bounds.minY + 0.11394 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + -0.00845 * bounds.width, y: bounds.minY + 0.05913 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.14773 * bounds.width, y: bounds.minY + 0.02534 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.05915 * bounds.width, y: bounds.minY + -0.00845 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.11392 * bounds.width, y: bounds.minY + -0.00845 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.50000 * bounds.width, y: bounds.minY + 0.37761 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.85227 * bounds.width, y: bounds.minY + 0.02534 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.97466 * bounds.width, y: bounds.minY + 0.02534 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 0.88608 * bounds.width, y: bounds.minY + -0.00845 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 0.94085 * bounds.width, y: bounds.minY + -0.00845 * bounds.height))
        crossPath.addCurve(to: CGPoint(x: bounds.minX + 0.97466 * bounds.width, y: bounds.minY + 0.14773 * bounds.height), controlPoint1: CGPoint(x: bounds.minX + 1.00845 * bounds.width, y: bounds.minY + 0.05913 * bounds.height), controlPoint2: CGPoint(x: bounds.minX + 1.00845 * bounds.width, y: bounds.minY + 0.11394 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.62239 * bounds.width, y: bounds.minY + 0.50000 * bounds.height))
        crossPath.addLine(to: CGPoint(x: bounds.minX + 0.97466 * bounds.width, y: bounds.minY + 0.85227 * bounds.height))
        crossPath.close()
        crossPath.miterLimit = 4;
        
        crossPath.usesEvenOddFillRule = true;
        fillColor.setFill()
        crossPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
