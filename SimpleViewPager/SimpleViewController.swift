//
//  SimpleViewController.swift
//  SimpleViewPager
//
//  Created by YuheiMiyazato on 4/7/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

import UIKit

class MenuElem: NSObject {
    let NameKey = "name"
    let ClassNameKey = "cn"
    let StoryBoardKey = "sb"
    var menu: Dictionary<String,String> = [:]
    
    init(name: String, className: String, sbName: String) {
        menu[NameKey] = name
        menu[ClassNameKey] = className
        menu[StoryBoardKey] = sbName
    }
    
    func name() -> String {
        return menu[NameKey]!
    }
    func className() -> String {
        return menu[ClassNameKey]!
    }
    func storyBoardName() -> String {
        return menu[StoryBoardKey]!
    }
}

// taken from http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
// thanks!
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class SimpleViewController: UIViewController, UIScrollViewDelegate, MenuViewDelegate {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var menuView: MenuView!
    var vcs :Array<UIViewController>! = []
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        let menus: Array<MenuElem> =
        [
            MenuElem(name: "menu1", className: "SomeViewController", sbName: "Some"),
            MenuElem(name: "menu2", className: "SomeViewController", sbName: "Some"),
            MenuElem(name: "menu3", className: "SomeViewController", sbName: "Some"),
            MenuElem(name: "menu4", className: "SomeViewController", sbName: "Some"),
            MenuElem(name: "menu5", className: "SomeViewController", sbName: "Some"),
            MenuElem(name: "menu6", className: "SomeViewController", sbName: "Some"),
        ]
        
        self.menuView.setup(menus, delegate:self)
        self.setupContentScrollView(menus)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.contentScrollView.contentSize =
            CGSizeMake(CGFloat(self.vcs.count) * self.contentScrollView.frame.width,
                self.contentScrollView.frame.height)
        
        var cnt = 0
        let rect = self.contentScrollView.frame
        for view in self.contentScrollView.subviews as [UIView] {
            view.frame = CGRectMake(CGFloat(cnt) * rect.width, 0, rect.width, rect.height)
            cnt++
        }
        
        // Work around to prevent slipped frame of each menu when rotating
        self.scrollToPage(self.menuView.pageControl.currentPage)
        
        self.view.layoutSubviews()
    }
    
    // MARK: - instance methods
    func setupContentScrollView(menus: Array<MenuElem>) {
        
        // http://app.coolors.co/e0acd5-3993dd-29e7cd-6a3e37-c7f0bd
        let colorPalette = [0xE0ACD5, 0x3993DD, 0x29E7CD, 0x6A3E37, 0xC7F0BD]
        var cnt = 0
        for menu in menus {
            let sb: UIStoryboard = UIStoryboard(name: menu.storyBoardName(), bundle: nil)
            let vc = sb.instantiateInitialViewController() as UIViewController
            vc.menu = menu
            vc.view.backgroundColor = UIColor(netHex: colorPalette[cnt%colorPalette.count])
            self.contentScrollView.addSubview(vc.view)
            self.vcs.append(vc)
            cnt++
        }
    }
    
    func scrollToPage(newPage :Int) {
        
        let scrlViewRect = self.contentScrollView.frame
        let visibleRect = CGRectMake(CGFloat(newPage) * scrlViewRect.width,
            scrlViewRect.origin.y, scrlViewRect.width, scrlViewRect.height)
        self.contentScrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentPage = self.menuView.pageControl.currentPage
        
        let pageWidth = scrollView.frame.width
        let newPage = floor( ( scrollView.contentOffset.x - pageWidth * 0.5 ) / pageWidth ) + 1
        if currentPage != Int(newPage) && self.contentScrollView.dragging {
            self.menuView.changePage(Int(newPage), needScrollToVisible: true)
        }
    }
    
    // MARK: - MenuViewDelegate
    func menuViewDidScroll(sender: MenuView) {
        self.scrollToPage(sender.pageControl.currentPage)
    }
}

