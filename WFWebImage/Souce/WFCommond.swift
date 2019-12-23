//
//  Commond.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/16.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import CommonCrypto

public enum ExpirationDate {
    /// The item never expires.
    case never
    /// The item expires after a time duration of given seconds from now.
    case seconds(TimeInterval)
    /// The item expires after a time duration of given days from now.
    case days(Int)
    /// The item expires after a given date.
    case date(Date)

    func appendSince(_ date: Date) -> Date {
        switch self {
        case .never: return .distantFuture
        case .seconds(let seconds):
            return date.addingTimeInterval(seconds)
        case .days(let days):
            let duration = TimeInterval(86400 * days)
            return date.addingTimeInterval(duration)
        case .date(let ref):
            return ref
        }
    }
    
    var isExpired: Bool {
        return timeInterval <= 0
    }

    var timeInterval: TimeInterval {
        switch self {
        case .never: return .infinity
        case .seconds(let seconds): return seconds
        case .days(let days): return TimeInterval(86400 * days)
        case .date(let ref): return ref.timeIntervalSinceNow
        }
    }
}

extension String {
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(str!, strLen, result)
        var hash = ""
        for i in 0..<digestLen {
            hash.append(String.init(format: "%02x", result[i]))// appendFormat()
        }
        result.deallocate()
        return String(format: hash )
    }
}
