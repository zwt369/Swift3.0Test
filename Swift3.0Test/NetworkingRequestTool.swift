//
//  NetworkingRequestTool.swift
//  Swift3.0Test
//
//  Created by 百变家装002 on 16/10/9.
//  Copyright © 2016年 百变家装002. All rights reserved.
//

import UIKit

/**
 文件工具
 */
class FileConfigTool: NSObject {
    /** 文件数据*/
    var fileData: Data!
    /** 服务器接收参数名*/
    var name: String!
    /** 文件名*/
    var fileName: String!
    /** 文件类型*/
    var mimeType:String!
    
    class func initWithFileData(fileData:Data,name:String,fileName:String,mimeType:String) -> FileConfigTool {
        let file = FileConfigTool()
        file.fileData = fileData
        file.name = name
        file.fileName = fileName
        file.mimeType = mimeType
        return file
    }
}


class NetworkingRequestTool: NSObject {
    /**
     网络请求成功返回
     */
    typealias requestSuccessReback = (Any) -> Void
    /**
     网络请求失败返回
     */
    typealias requestFaileReback = (Error) -> Void
    /**
     网络请求响应
     */
    typealias requestDataReback = (Any?,Error?) -> Void
    /**
     响应进度返回
     */
    typealias progressReback = (Int64,Int64,Int64) -> Void
    /**
     上传进度
     */
    typealias uploadProgressReback = (Float) -> Void
    
    /** 网络请求manager*/
    var netManager:AFHTTPSessionManager = AFHTTPSessionManager() {
        didSet{
            //请求时长
            netManager.requestSerializer.timeoutInterval = 10
        }
    }
    
    /**
     网络监听
     */
    func checkNetworkStatus() -> Bool {
        let reachabilityManager = AFNetworkReachabilityManager.shared()
        var netStatus = false
        reachabilityManager.setReachabilityStatusChange { (status) in
            switch status {
            case .unknown:
                netStatus = true
            case .reachableViaWiFi:
                netStatus = true
            case .reachableViaWWAN:
                netStatus = true
            default :
                netStatus = false
            }
        }
        reachabilityManager.startMonitoring()
        return netStatus
    }
    
    /**
     post请求
     */
      func postRequest(url:String,params:Dictionary<String,AnyObject>?,success:@escaping requestSuccessReback,faile:@escaping requestFaileReback) {
        self.netManager.post(url, parameters: params, progress: nil, success: { (task, response) in
            success(response)
        }) { (task, error) in
            faile(error)
        }
    }
    
    /**
     下载请求
     */
    func downloadRequst(url:String,progress:@escaping progressReback,complete:@escaping requestDataReback)  {
        if self.checkNetworkStatus() == false {
            progress(0,0,0)
            complete(nil,nil)
            return
        }
        let urlConfigure = URLSessionConfiguration()
        let session = AFURLSessionManager(sessionConfiguration: urlConfigure)
        let urlRequest = URLRequest(url: URL(string: url)!)
        let downLoadTask = session.downloadTask(with: urlRequest, progress: nil, destination: { (url, urlResponse) -> URL in
            do {
                let documentUrl = try FileManager.default.url(for:.documentDirectory , in: .userDomainMask, appropriateFor: nil, create: false)
                return documentUrl.appendingPathComponent(urlResponse.suggestedFilename!)
            }catch{
                return url
            }
        }) { (URLResponse, url, error) in
            complete(URLResponse,error)
        }
        
        session.setDownloadTaskDidWriteDataBlock { (urlSession, task, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite)
        }
        downLoadTask.resume()
    }
    
    /**
     文件上传，监听上传进度
     */
    func updateRequest(url:String,params:Dictionary<String,AnyObject>?,fileConfig:FileConfigTool,successAndProgress:@escaping uploadProgressReback,complete:@escaping requestDataReback)  {
        netManager.post(url, parameters: params, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: fileConfig.fileData, name: fileConfig.name, fileName: fileConfig.fileName, mimeType: fileConfig.mimeType)
            }, progress: { (progress) in
                let comptedpad = Float(progress.completedUnitCount)
                let total = Float(progress.totalUnitCount)
                successAndProgress(comptedpad/total)
            }, success: { (task, response) in
                complete(response,nil)
            }) { (task, error) in
                complete(nil,error)
        }
    }
    
}

