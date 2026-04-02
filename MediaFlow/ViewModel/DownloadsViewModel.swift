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
    // to keep track of downloaded items
    @Published var downloadStates: [Int: DownloadState] = [:]
    
    private var networkService: ServiceAPIProtocol
    
    init( networkService: ServiceAPIProtocol) {
        
        self.networkService = networkService
    }
 
    
    
    func makeMediaRequest() -> URLRequest {
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        return URLRequest(url: url)
    }
    
    
    func state(for item: MediaItem) -> DownloadState {
        downloadStates[item.id] ?? .notStarted
    }
    func getDataForMediaListing()  {
        
        //call api from network layer
        
        let request = makeMediaRequest()
        
        Task {
            
            let mediaItems : [MediaItem] =  try await self.networkService.fetchRequest(request)
            self.mediaItems = mediaItems
            // 2. Initialize states
            var initialStates: [Int: DownloadState] = [:]
            
            for item in mediaItems {
                initialStates[item.id] = .notStarted
            }
            
            self.downloadStates = initialStates
            
        }
    }
}
