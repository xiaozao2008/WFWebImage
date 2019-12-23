//
//  WF.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/16.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension WFWebImage where Base == UIImageView {
    
    public func image(_ source: Source, placeholder: UIImage? = nil, progress: DownloadRequest.ProgressHandler? = nil, complate: ((Result<UIImage>) -> Void)? = nil) {
        base.image = placeholder
        if let image = source.source {
            base.image = image
            if let key = source.url?.absoluteString {
                saveToMemory(image, key: key)
                saveToDisk(image.pngData(), key: key)
            }
        }
        if let url = source.url {
            let key = url.absoluteString
            if let image = WFWebImageConfig.default.memoryCache[key] {
                base.image = image
                complate?(.success(image))
                return
            }
            
            if let objc = try? WFWebImageConfig.default.diskCache.value(key), let image = UIImage(data: objc.value) {
                base.image = image
                saveToMemory(image, key: key)
                complate?(.success(image))
                return
            }
            if let task = WFNetwork.taskings[url] {
                if let progress = progress {
                    progress(task.progress)
                }
                task.responseData(completionHandler: { (response) in
                    if let data = response.result.value, let image = UIImage(data: data) {
                        self.base.image = image
                        complate?(Result.success(image))
                        self.saveToMemory(image, key: key)
                        self.saveToDisk(data, key: key)
                        return
                    }
                })
            }
            WFRequest(WFNetwork.default.sessionManager).request(url, progress: progress) { (result) in
                switch result.result  {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        self.base.image = image
                        self.saveToMemory(image, key: key)
                        self.saveToDisk(data, key: key)
                        complate?(.success(image))
                    }
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveToMemory(_ image: UIImage, key: String) {
        WFWebImageConfig.default.memoryCache[key] = image
    }
    
    private func saveToDisk(_ image: Data?, key: String) {
        if let data = image {
            try? WFWebImageConfig.default.diskCache.store(DiskStroage.init(value: data, key: key))
        }
    }
}

public struct WFWebImage<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

// For Example
public class WFDiskConfigObjc: WFDiskConfig {
    
    public var manager: FileManager = .default
    public var maxDate: ExpirationDate = .days(7)
    public var maxSize: Int64 = .max
    public var saveCachePath: URL = {
        let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
        .userDomainMask, true).first!
        var baseUrl = URL(fileURLWithPath: basePath)
        baseUrl.appendPathComponent("defalut_\(#function)")
        return baseUrl
    }()
    public var diskQueue: DispatchQueue = DispatchQueue.init(label: "WKDiskQueue_\(UUID().uuidString)")
    required public init() {}
}

public class WFWebImageConfig {
    static let `default` = WFWebImageConfig()
    var diskConfig: WFDiskConfig = WFDiskConfigObjc()
    lazy var diskCache: WFDiskCache =  WFDiskCache(diskConfig)
    var memoryCache = WFMemoryCache()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeStrongMemory), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeStrongMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeDiskExpiredOrLimit), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func removeDiskExpiredOrLimit() {
        WFWebImageConfig.default.memoryCache.removeStongReferecen()
    }
    
    @objc func removeStrongMemory() {
        try? WFWebImageConfig.default.diskCache.removeExpiredOrLimit()
    }
    
}
