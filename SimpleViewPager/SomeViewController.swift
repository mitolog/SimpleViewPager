//
//  SomeViewController.swift
//  SimpleViewPager
//
//  Created by YuheiMiyazato on 4/8/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

import Foundation
import UIKit

var menuElemSelector: Selector = Selector("menuElem")

extension UIViewController {
    
    var menu: MenuElem {
        get {
            return objc_getAssociatedObject(self, &menuElemSelector) as! MenuElem
        }
        set {
            objc_setAssociatedObject(self, &menuElemSelector, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) ;
        }
    }
}

class SomeViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        self.label.text = self.menu.name()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}