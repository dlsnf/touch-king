//
//  ViewInfoController.swift
//  quicktouch
//
//  Created by nuri Lee on 22/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//


import UIKit

class ViewInfoController: UIViewController {

    @IBOutlet weak var btnDismiss: UIButton!
    
    @IBAction func btnDimissPress(_ sender: Any) {
        
        self.dismiss(animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //라이트모드
        overrideUserInterfaceStyle = .light
        
        
    }
}
