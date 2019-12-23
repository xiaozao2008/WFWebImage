//
//  WFError.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/16.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation

public enum WFError: Error {
    
    public enum DiskError {
        case create(_ error: Error, _ path: String)
        case store(_ error: Error)
        case storeSetAttributes(_ error: Error)
        case meta(_ error: Error)
        case toData(_ error: Error)
        case remove(_ error: Error)
        case removeAll(_ error: Error)
        case createDirectory(_ error: Error)
    }
    case diskError(DiskError)
    
}

extension WFError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .diskError(diskError):
            switch diskError {
            case let .create(error, path):
                return "WFErrorr: \(error.localizedDescription), path: \(path)"
            case let .store(error):
                return "WFErrorr: \(error.localizedDescription), store failture"
            case let .meta(error):
                return "WFErrorr: \(error.localizedDescription),  read meta failture"
            case let .toData(error):
                return "WFErrorr: \(error.localizedDescription),  file toData failture"
            case let .remove(error):
                return "WFErrorr: \(error.localizedDescription),  remove file failture"
            case let .removeAll(error):
                return "WFErrorr: \(error.localizedDescription),  remove all failture"
            case let .createDirectory(error):
                return "WFErrorr: \(error.localizedDescription),  createDirectory failture"
            case let .storeSetAttributes(error):
                return "WFErrorr: \(error.localizedDescription),  storeSetAttributes failture"
            }
        }
    }
}
