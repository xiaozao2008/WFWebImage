//
//  Protocol.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/20.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import UIKit

public protocol WFWebImageWapper {}

/// Image(_ source: Source)
public protocol Source {
    var url: URL? { get }
    var source: UIImage? { get }
}

/// Disk Cache Config
public protocol WFDiskConfig {
    var maxDate: ExpirationDate { get }
    var maxSize: Int64 { get }
    var manager: FileManager { get }
    var saveCachePath: URL { get }
    var diskQueue: DispatchQueue { get }
    init()
}
