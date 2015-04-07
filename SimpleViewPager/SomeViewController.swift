//
//  SomeViewController.swift
//  SimpleViewPager
//
//  Created by YuheiMiyazato on 4/8/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

import Foundation
import UIKit

class SomeViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        self.label.text = self.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}