//
//  DownloadItem.swift
//  MediaFlow
//
//  Created by Arpana Rani on 23/04/26.
//


struct DownloadItem: Identifiable, Decodable {
    let id: String
    let url: String
    
    var state: DownloadState = .notStarted

    enum CodingKeys: String, CodingKey {
        case id
        case url = "download_url"
    }
    
    func iconName(for state: DownloadState) -> String {
        switch state {
        case .notStarted:
            return "arrow.down.circle"
            
        case .downloading:
            return "pause.circle"
            
        case .paused:
            return "play.circle"
            
        case .completed:
            return "checkmark.circle"
            
        case .failed:
            return "arrow.clockwise.circle"

        }
    }
    
}

