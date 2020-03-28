//
//  RotateLabel.swift
//  quicktouch
//
//  Created by nuri Lee on 26/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//

import UIKit

@IBDesignable
class RotateLabel:UILabel {

    @IBInspectable var label_Rotation: Double = 0 {
        didSet {
            rotateLabel(labelRotation: label_Rotation)
            self.layoutIfNeeded()
        }
    }

    func rotateLabel(labelRotation: Double)  {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * 2) + labelRotation))
    }
}
