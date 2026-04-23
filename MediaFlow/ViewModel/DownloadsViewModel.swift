//
//  DownloadsViewModel.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Combine
import Foundation

@MainActor
class DownloadsViewModel: ObservableObject {
   
    // Holds all available media items (source data)
    @Published var mediaItems: [MediaItem] = []
    
    // Tracks download state/progress for media items
    @Published var downloadItem : [DownloadItem] = []
    
    private var networkService: ServiceAPIProtocol
    
    init( networkService: ServiceAPIProtocol) {
        
        self.networkService = networkService
    }
    
    func makeMediaRequest() -> URLRequest {
        let url = URL(string:"https://picsum.photos/v2/list")! //"https://jsonplaceholder.typicode.com/photos")!
        return URLRequest(url: url)
    }

    func getDataForMediaListing()  {
        
        //call api from network layer
        let request = makeMediaRequest()
        
        Task {
            
            let mediaItems : [MediaItem] =  try await self.networkService.fetchRequest(request)
            let downloadItem : [DownloadItem] =  try await self.networkService.fetchRequest(request)
            self.mediaItems = mediaItems
            self.downloadItem = downloadItem
        }
    }
    
    func downlodadIfNeeded(for item: MediaItem) {
        
        // Find the index of the tapped item in the data source
        guard let index = mediaItems.firstIndex(where: { $0.id == item.id }) else { return }
        
        // Immediately update state to show download has started
        mediaItems[index].downloadState = .downloading(progress: 0.0)
        
        // Start the download using DownloadManager
        DownloadManager.shared.startDownload(
            with: URL(string: item.url)!,
            itemId: item.id
        ) { [weak self] id, progress in
            
            // Update progress for the correct item using returned itemId
            guard let index = self?.mediaItems.firstIndex(where: { $0.id == id }) else { return }
            self?.mediaItems[index].downloadState = .downloading(progress: progress)
            
        } completion: { [weak self] id, localURL in
            
            // Mark item as completed and store the local file URL
            guard let index = self?.mediaItems.firstIndex(where: { $0.id == id }) else { return }
            self?.mediaItems[index].downloadState = .completed(localURL: localURL)
            
        } failure: { [weak self] id in
            
            // Mark item as failed if download encounters an error
            guard let index = self?.mediaItems.firstIndex(where: { $0.id == id }) else { return }
            self?.mediaItems[index].downloadState = .failed
        }
        
    }

    
    func pauseDownload(for item: DownloadItem) {
        
        guard let index = downloadItem.firstIndex(where: { $0.id == item.id }) else { return }
        
        guard case .downloading(let progress) = downloadItem[index].state else {
            return   // Only pause if actually downloading
        }
        
        DownloadManager.shared.pauseDownload(itemId: item.id)
        
        downloadItem[index].state = .paused(progress: progress)
    }

    func resumeDownload(for item: DownloadItem) {
        guard let url = URL(string: "https://proof.ovh.net/files/100Mb.dat") else { return }
        
        DownloadManager.shared.resumeDownload(itemId: item.id, url: url)
        
        if let index = downloadItem.firstIndex(where: { $0.id == item.id }),
           case .paused(let progress) = mediaItems[index].downloadState {
            mediaItems[index].downloadState = .downloading(progress: progress)
        }
    }
    
    func downloadFullImageIfNeeded(for item: DownloadItem) {
        
        guard let index = downloadItem.firstIndex(where: { $0.id == item.id }),
              
                // This URL points to a large (~100MB) test file hosted on OVH's public test server.
              // It is intentionally used instead of typical image APIs (like Picsum/Unsplash) to
                // demonstrate a reliable download system with pause and resume support.
                //
                // Why this URL is used:
                // - Supports HTTP byte-range requests (Accept-Ranges: bytes), which is required
                //   for URLSessionDownloadTask to generate valid resumeData.
                // - Large file size ensures visible progress updates and allows testing pause/resume.
                // - Does not rely on CDN redirects, which often break resume functionality.
                // - Provides consistent and predictable behavior across different network conditions.
                //
                // Note:
                // Image-based APIs are avoided here because they often use CDN redirection and
                // small file sizes, making pause/resume unreliable or ineffective for demonstration.
                
                let url = URL(string: "https://proof.ovh.net/files/100Mb.dat") else { return }
        
        let localURL = localFilePath(for: url)
        
        // CACHE HIT
        if FileManager.default.fileExists(atPath: localURL.path) {
            downloadItem[index].state = .completed(localURL: localURL)
            return
        }
        
        if case .paused = self.downloadItem[index].state {
            return
        }
        
        // Start download
        downloadItem[index].state = .downloading(progress: 0.0)
        
        
        DownloadManager.shared.startDownload(
            with: url,
            itemId: item.id
        ) { [weak self] id, progress in
            
            guard let self,
                  let index = self.downloadItem.firstIndex(where: { $0.id == id }) else { return }
            
            self.downloadItem[index].state = .downloading(progress: progress)
            
        } completion: { [weak self] id, localURL in
            
            guard let self,
                  let index = self.downloadItem.firstIndex(where: { $0.id == id }) else { return }
            
            self.downloadItem[index].state = .completed(localURL: localURL)
            
        } failure: { [weak self] id in
            
            guard let self,
                  let index = self.downloadItem.firstIndex(where: { $0.id == id }) else { return }
            
            self.downloadItem[index].state = .failed
        }
    }
    func handleDownloadAction(for item: DownloadItem) {
        
        guard let index = downloadItem.firstIndex(where: { $0.id == item.id }) else { return }

        switch downloadItem[index].state {

        case .notStarted:
            downloadFullImageIfNeeded(for: item)
            
        case .downloading:
            pauseDownload(for: item)
            
        case .paused:
            resumeDownload(for: item)
            
        case .failed:
            downloadFullImageIfNeeded(for: item)
            
        case .completed:
            print("Already downloaded") // or open image later
        }
    }
}
