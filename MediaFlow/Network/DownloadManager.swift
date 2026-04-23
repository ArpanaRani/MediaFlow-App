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
    
    private var activeDownloads: [String: (task: URLSessionDownloadTask, resumeData: Data?)] = [:]
    
    private lazy  var session: URLSession = {
        
        URLSession(configuration: NetworkConfigurations.downloadConfiguration,
                   delegate : self,
                   delegateQueue :nil)
        
    }()
    
    func startDownload(
        with url: URL,
        itemId: String,
        progress: @escaping (String, Double) -> Void,
        completion: @escaping (String, URL) -> Void,
        failure: @escaping (String) -> Void
    ) {
        
        let task: URLSessionDownloadTask
        
        //  Check if resume data exists
        if let resumeData = activeDownloads[itemId]?.resumeData {
            
            print("Resuming download for item:", itemId)
            
            task = session.downloadTask(withResumeData: resumeData)
            
            // Clear resumeData once used
            activeDownloads[itemId] = (task, nil)
            
        } else {
            
            print("Starting fresh download for item:", itemId)
            
            task = session.downloadTask(with: url)
            activeDownloads[itemId] = (task, nil)
        }
        
        // Handlers
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
        DispatchQueue.main.async {
            self.progressHandlers[downloadTask]?(progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        print("Resumed at: \(fileOffset) / \(expectedTotalBytes)")

    }
    
    func urlSession( _ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?
    ) {
        
        guard let downloadTask = task as? URLSessionDownloadTask else { return }
        
        if let error = error as NSError? {
            //  Ignore cancel error (pause case)
            if error.code == NSURLErrorCancelled {
                print("Download paused")
                return
            }
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
        
        //  remove from activeDownloads
        if let itemId = activeDownloads.first(where: { $0.value.task == task })?.key {
            activeDownloads[itemId] = nil
        }
    }
}

extension DownloadManager {
    
    //MARK: - Add Pause function
    func pauseDownload(itemId: String) {
        guard let entry = activeDownloads[itemId] else { return }
        
        entry.task.cancel { resumeData in
            self.activeDownloads[itemId]?.resumeData = resumeData
        }
    }
    
    //MARK: - Add Resume function
    func resumeDownload(itemId: String, url: URL) {
        guard let entry = activeDownloads[itemId] else { return }
        
        let task: URLSessionDownloadTask
        
        if let resumeData = entry.resumeData {
            task = session.downloadTask(withResumeData: resumeData)
        } else {
            task = session.downloadTask(with: url)
        }
        
        // Update stored task
        activeDownloads[itemId]?.task = task
        
        // Reattach handlers 
        progressHandlers[task] = progressHandlers[entry.task]
        completionHandlers[task] = completionHandlers[entry.task]
        failureHandlers[task] = failureHandlers[entry.task]
        
        task.resume()
    }
}
