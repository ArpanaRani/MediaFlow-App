//
//  DownloadManager.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation

final class DownloadManager: NSObject , URLSessionDownloadDelegate {
    
    static let shared = DownloadManager()
    
    private var progressHandlers: [URLSessionDownloadTask: (Double) -> Void] = [:]
    private var completionHandlers: [URLSessionDownloadTask: (URL) -> Void] = [:]
    private var failureHandlers: [URLSessionDownloadTask: () -> Void] = [:]
    
    private lazy  var session: URLSession = {
        
        URLSession(configuration: NetworkConfigurations.downloadConfiguration,
                   delegate : self,
                   delegateQueue :nil)
        
    }()
    
    func startDownload( with url: URL,   itemId: String,  progress: @escaping (String, Double) -> Void,  completion: @escaping (String, URL) -> Void,  failure: @escaping (String) -> Void
    ) {
        let task = session.downloadTask(with: url)
                
        progressHandlers[task] = { value in
            progress(itemId, value)
        }
        
        completionHandlers[task] = { localURL in
            completion(itemId, localURL)
        }
        
        failureHandlers[task] = {
            failure(itemId)
        }
        
        task.resume()
    }

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Download completed:")

        DispatchQueue.main.async {
                self.completionHandlers[downloadTask]?(location)
                
                self.cleanupTaskInfo(task: downloadTask)
            }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
           
        print("Download progress: \(progress * 100)%")
        print(downloadTask.taskIdentifier)
        print(downloadTask.taskIdentifier)

        DispatchQueue.main.async {
            self.progressHandlers[downloadTask]?(progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
    }
    
    func urlSession( _ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?
    ) {
        guard let downloadTask = task as? URLSessionDownloadTask else { return }
        
        if let error = error {
            print("Download failed:", error)
            
            DispatchQueue.main.async {
                self.failureHandlers[downloadTask]?()
                self.cleanupTaskInfo(task: downloadTask)
            }
        }
    }
    
    private func cleanupTaskInfo(task: URLSessionDownloadTask) {
        progressHandlers[task] = nil
        completionHandlers[task] = nil
        failureHandlers[task] = nil
    }
}
