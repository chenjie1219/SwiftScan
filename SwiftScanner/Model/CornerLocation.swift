//
//  CornerLocation.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

public enum CornerLocation {
    /// 默认与边框线同中心点
    case `default`
    /// 在边框线内部
    case inside
    /// 在边框线外部
    case outside
}
