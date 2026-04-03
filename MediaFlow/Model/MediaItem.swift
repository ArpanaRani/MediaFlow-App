//
//  MediaItem.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//


struct MediaItem: Identifiable, Decodable {
    
    let id: String
    let title: String
    let url: String

    var downloadState: DownloadState = .notStarted

    enum CodingKeys: String, CodingKey {
        case id
        case title = "author"
        case url = "download_url"
    }
    
    func iconName(for state: DownloadState) -> String {
        switch state {
        case .notStarted:
            return "arrow.down.circle" 
            
        case .downloading:
            return "pause.circle"   
            
        case .completed:
            return "checkmark.circle"
            
        case .failed:
            return "arrow.clockwise.circle"
        }
    }
    
}
extension MediaItem {
    
    var thumbnailUrl: String {
        "https://picsum.photos/id/\(id)/150/150"
    }
    
    var fullImageUrl: String {
        "https://picsum.photos/id/\(id)/600/600"
    }
}
