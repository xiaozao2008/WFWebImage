//
//  WFNetwork.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/20.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import Foundation
import Alamofire

class WFNetwork: NSObject {
    static let `default` = WFNetwork()
    static var taskings = [URL: DownloadRequest]() // 当前Request
    var sessionManager = SessionManager.default
}

class WFRequest {
    
    private let sessionManager: SessionManager
    init(_ manager: SessionManager) {
        self.sessionManager = manager
    }
    
    @discardableResult
    func request(_ imageUrl: URLConvertible, progress: DownloadRequest.ProgressHandler?, response: ((DownloadResponse<Data>) -> Void)?) -> DownloadRequest? {
        guard let url = try? imageUrl.asURL() else { return nil }
        
        let downLoadPath: DownloadRequest.DownloadFileDestination = { url,response in
            return (WFWebImageConfig.default.diskConfig.saveCachePath.appendingPathComponent(url.absoluteString.md5), [])
        }
        let downloadRequest = sessionManager.download(imageUrl, to: downLoadPath)
        WFNetwork.taskings[url] = downloadRequest
        if let progress = progress {
            print(progress)
            downloadRequest.downloadProgress(closure: progress)
        }
        downloadRequest.responseData { (responseData) in
            response?(responseData)
            WFNetwork.taskings.removeValue(forKey: url)
        }
        return downloadRequest
    }
}

 
