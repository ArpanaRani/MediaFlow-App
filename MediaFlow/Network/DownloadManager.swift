//
//  DownloadManager.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation

final class DownloadManager: NSObject , URLSessionDownloadDelegate {
    
    static let shared = DownloadManager()
    
    private lazy  var session: URLSession = {
        
        URLSession(configuration: NetworkConfigurations.downloadConfiguration,
                   delegate : self,
                   delegateQueue :nil)
        
    }()
    
    
    func startDownload(with url: URL) {
        
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
    }
    
    
}
