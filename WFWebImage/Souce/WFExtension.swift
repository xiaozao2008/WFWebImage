//
//  Extension.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/20.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import UIKit

extension WFWebImageWapper {
    var wf: WFWebImage<Self> {
        set { }
        get { return WFWebImage(self) }
    }
}

extension UIImageView: WFWebImageWapper {}

extension String: Source {
    public var url: URL? {
        return URL(string: self)
    }
    public var source: UIImage? {
        return nil
    }
}

extension URL: Source {
    public var url: URL? {
        return self
    }
    public var source: UIImage? {
        return nil
    }
}
