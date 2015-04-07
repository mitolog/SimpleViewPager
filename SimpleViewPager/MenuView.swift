//
//  MenuView.swift
//  SimpleViewPager
//
//  Created by YuheiMiyazato on 4/7/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

import Foundation
import UIKit

struct MenuViewConsts {
    
    static let alpha :CGFloat = 0.7
    
    struct Label {
        static let align = NSTextAlignment.Center
        static let onColor = UIColor.whiteColor()
        static let offColor = UIColor.lightGrayColor()
        static let onFont = UIFont(name: "HiraKakuProN-W6", size: 15)
        static let offFont = UIFont(name: "HiraKakuProN-W3", size: 12)
    }
}

protocol MenuViewDelegate :NSObjectProtocol {
    func menuViewDidScroll(sender :MenuView)
}

class MenuView: UIView, UIScrollViewDelegate {
    
    var delegate: MenuViewDelegate!
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var menuCnt = 0
    let scrlVWidthConstraintId = "scrollViewWidthConstraint"
    
    // MARK: - instance methods
    func setup(menus : Array<MenuElem>, delegate: MenuViewDelegate!) {
        
        self.menuCnt = menus.count
        self.delegate = delegate

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "menuTapped:"))
        self.alpha = MenuViewConsts.alpha
        
        // UIScrollview as a base view for pasting each menu title
        self.scrollView = UIScrollView(frame: CGRectZero)
        self.scrollView.pagingEnabled = true
        self.scrollView.clipsToBounds = false  // to be able to appear each menu title outside scrollView bounds
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(self.scrollView)

        // UILabel for each menu title
        var cnt = 0
        for aMenu in menus {
            var label: UILabel = UILabel(frame: CGRectZero)
            label.textAlignment = MenuViewConsts.Label.align
            label.adjustsFontSizeToFitWidth = true
            label.text = aMenu.name()
            label.tag = Int(cnt) // Sync with self.pageControl's currentPage
            label.textColor = (cnt==0) ? MenuViewConsts.Label.onColor : MenuViewConsts.Label.offColor
            self.scrollView.addSubview(label)
            
            cnt++
        }
        
        // UIPageControl (just instansiate, not visible to a user)
        self.pageControl = UIPageControl(frame: CGRectZero)
        self.pageControl.numberOfPages = self.menuCnt
    }
    
    func changeLabelAttributes(scrollView: UIScrollView, currentPage: Int) {
        
        for label in scrollView.subviews as [UILabel] {
            if !label.isKindOfClass(UILabel) { continue }
            if label.tag == currentPage {
                label.textColor = MenuViewConsts.Label.onColor
                label.font = MenuViewConsts.Label.onFont
            }else{
                label.textColor = MenuViewConsts.Label.offColor
                label.font = MenuViewConsts.Label.offFont
            }
        }
    }
    
    func changePage(newPage :Int, needScrollToVisible: Bool) {
        
        self.pageControl.currentPage = newPage
        
        if needScrollToVisible {
            let visibleRect = CGRectMake(
                self.scrollView.frame.width * CGFloat(newPage),
                self.scrollView.frame.origin.y,
                self.scrollView.frame.width,
                self.scrollView.frame.height)
            self.scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
        
        self.changeLabelAttributes(self.scrollView, currentPage: newPage)
    }
    
    // MARK: - callbacks
    func menuTapped(tapRecog: UITapGestureRecognizer) {
        
        let currentPt = tapRecog.locationInView(self.scrollView)
        if currentPt.x < 0 || currentPt.x > self.scrollView.contentSize.width { return }
        
        var tappedPage = 0
        var aMenuWidth = self.scrollView.frame.width
        for i in 1...self.menuCnt {
            if currentPt.x <= aMenuWidth*CGFloat(i) {
                tappedPage = i-1
                break
            }
        }
        
        self.changePage(tappedPage, needScrollToVisible: true)
        
        // Notify delegate
        if self.delegate.respondsToSelector("menuViewDidScroll:") {
            self.delegate.menuViewDidScroll(self)
        }
    }
    
    // MARK: - override methods
    override func layoutSubviews() {
        
        super.layoutSubviews()

        // Update each view parts' frame
        
        let scrlViewWidth = CGRectGetWidth(self.frame)/CGFloat(self.menuCnt)
        let scrlViewRect =
        CGRectMake(
            CGRectGetWidth(self.frame)*0.5 - scrlViewWidth*0.5 ,0,
            scrlViewWidth, CGRectGetHeight(self.frame)
        )
        self.scrollView.frame = scrlViewRect
        
        var cnt = 0
        for label in self.scrollView.subviews as [UILabel] {
            if !label.isKindOfClass(UILabel) { continue }
            
            let labelFrame = CGRectMake(
                CGFloat(cnt)*scrlViewRect.width,0,
                scrlViewRect.width, scrlViewRect.height)
            label.frame = labelFrame as CGRect
            
            cnt++
        }
        
        self.scrollView.contentSize = CGSizeMake(scrlViewRect.width * CGFloat(cnt), scrlViewRect.height);
        
        // Work around to prevent slipped frame of each menu when rotating
        self.changePage(Int(self.pageControl.currentPage), needScrollToVisible: true)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // Check if within own bounds. If YES, pass touch event to scrollView
        if self.pointInside(point, withEvent: event) {
            return self.scrollView
        }
        return nil
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let newPage = floor( ( scrollView.contentOffset.x - pageWidth * 0.5 ) / pageWidth ) + 1
        if self.pageControl.currentPage != Int(newPage) && self.scrollView.dragging {
            
            self.changePage(Int(newPage), needScrollToVisible: false)

            // Notify delegate
            if self.delegate.respondsToSelector("menuViewDidScroll:") {
                self.delegate.menuViewDidScroll(self)
            }
        }
    }
}