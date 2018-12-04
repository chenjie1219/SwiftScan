//
//  Common.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

let bundle = Bundle(path: Bundle.main.path(forResource: "SwiftScanner.bundle", ofType: nil) ?? "")

let screenWidth = UIScreen.main.bounds.width

let screenHeight = UIScreen.main.bounds.height

let statusHeight = UIApplication.shared.statusBarFrame.height


public func imageNamed(_ name:String)-> UIImage{
    
    guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else{
        return UIImage()
    }
    
    return image
    
}
