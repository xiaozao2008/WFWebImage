//
//  WFMemoryCache.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/16.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import UIKit

//extension AnyObject
extension UIImage {
    struct SaveTimeStruct {
        static var time = "WFMemoryCache_TimeKey_tony.wang"
    }
    
    var time: Date? {
        set {
            objc_setAssociatedObject(self, &SaveTimeStruct.time, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &SaveTimeStruct.time) as? Date
        }
    }
}

public class WFMemoryCache: NSCache<NSString, UIImage> {
    
    private let weakCache = NSMapTable<NSString, UIImage>(keyOptions: .weakMemory,
                                                             valueOptions: .weakMemory)
    private var keys = Set<String>()
    private let lock = NSLock()
    public override init() {
        super.init()
        Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [unowned self] (_) in
            self.removeExpired()
        }.fire()
        
    }
    
    func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        for key in keys {
            let expiredTime = Date.init(timeIntervalSinceNow: -300)
            if let objc = self.object(forKey: key as NSString) {
                if objc.time ?? Date.distantPast < expiredTime {
                    keys.remove(key)
                    self.removeObject(forKey: key as NSString)
                }
            } else {
                keys.remove(key)
            }
        }
    }
    
    subscript(key: String) -> UIImage? {
        set {
            lock.lock()
            defer { lock.unlock() }
            let nsKey = key as NSString
            if let newValue = newValue {
                newValue.time = Date()
                keys.insert(key)
                self.setObject(newValue, forKey: nsKey)
                self.weakCache.setObject(newValue, forKey: nsKey)
            } else {
                self.removeObject(forKey: nsKey)
                keys.remove(key)
                self.weakCache.removeObject(forKey: nsKey)
            }
        }
        get {
            lock.lock()
            defer { lock.unlock() }
            let nsKey = key as NSString
            var value = self.object(forKey: nsKey)
            if value == nil, !key.isEmpty {
                value = weakCache.object(forKey: nsKey)
            }
            if let value = value {
                setObject(value, forKey: nsKey)
                value.time = Date()
            }
            return value
        }
    }
    
    public override func removeAllObjects() {
        lock.lock()
        defer { lock.unlock() }
        super.removeAllObjects()
        self.weakCache.removeAllObjects()
        keys.removeAll()
    }
    
    public func removeStongReferecen() {
        super.removeAllObjects()
        keys.removeAll()
    }
}
