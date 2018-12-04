//
//  Platform.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

struct Platform {
    static let isSimulator: Bool = {
        #if swift(>=4.1)
          #if targetEnvironment(simulator)
            return true
          #else
            return false
          #endif
        #else
          #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
          #else
            return false
          #endif
        #endif
    }()
}
