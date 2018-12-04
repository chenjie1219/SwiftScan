//
//  ScanAnimation.swift
//  SwiftScanner
//
//  Created by Jason on 2018/12/3.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

class ScanAnimation:NSObject{
    
    static let shared:ScanAnimation = {
        
        let instance = ScanAnimation()
        
        return instance
    }()
    
    lazy var animationImageView = UIImageView()
    
    var displayLink:CADisplayLink?
    
    var tempFrame:CGRect?
    
    var contentHeight:CGFloat?
    
    func startWith(_ rect:CGRect, _ parentView:UIView, imageView:UIImageView) {
        
        tempFrame = rect
        
        imageView.frame = tempFrame ?? CGRect.zero
        
        animationImageView = imageView
        
        contentHeight = parentView.bounds.height
    
        parentView.addSubview(imageView)
        
        setupDisplayLink()
        
    }
    
    
    @objc func animation() {
        
        if animationImageView.frame.maxY > contentHeight! + 20 {
            animationImageView.frame = tempFrame ?? CGRect.zero
        }
        
        animationImageView.transform = CGAffineTransform(translationX: 0, y: 2).concatenating(animationImageView.transform)
        
    }
    
    
    func setupDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(animation))
        
        displayLink?.add(to: .current, forMode: .common)
        
        displayLink?.isPaused = true
        
    }
    
    
    func startAnimation() {
        
        displayLink?.isPaused = false
        
    }
    
    
    func stopAnimation() {
        
        displayLink?.invalidate()
        
        displayLink = nil
        
    }
    
}
