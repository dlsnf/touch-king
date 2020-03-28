//
//  RotateImageView.swift
//  quicktouch
//
//  Created by nuri Lee on 29/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//

import UIKit

@IBDesignable
class RotateImageView:UIImageView {

    @IBInspectable var imageView_Rotation: Double = 0 {
        didSet {
            rotateImageView(imageViewRotation: imageView_Rotation)
            self.layoutIfNeeded()
        }
    }

    func rotateImageView(imageViewRotation: Double)  {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * 2) + imageViewRotation))
    }
}
