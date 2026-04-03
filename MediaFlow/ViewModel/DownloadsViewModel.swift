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
    
    @Published var mediaItems: [MediaItem] = []
    
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
            self.mediaItems = mediaItems
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

}
