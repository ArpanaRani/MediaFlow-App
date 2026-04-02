//
//  MockSrviceAPI.swift
//  MediaFlow
//
//  Created by Arpana Rani on 02/04/26.
//



import Foundation
struct MockSrviceAPI: ServiceAPIProtocol {
    
    private let session = URLSession(configuration: NetworkConfigurations.apiConfiguration)

    func fetchRequest <T :Decodable>(_ urlRequest: URLRequest) async throws -> T {
        
        let mockMedia: [MediaItem] = [
            MediaItem(
                id: 1,
                title: "Beautiful Landscape",
                url: "https://picsum.photos/id/10/300/300",
                thumbnailUrl: "https://picsum.photos/id/10/100/100"
            ),
            MediaItem(
                id: 2,
                title: "Mountain View",
                url: "https://picsum.photos/id/20/300/300",
                thumbnailUrl: "https://picsum.photos/id/20/100/100"
            ),
            MediaItem(
                id: 3,
                title: "City Lights",
                url: "https://picsum.photos/id/30/300/300",
                thumbnailUrl: "https://picsum.photos/id/30/100/100"
            ),
            MediaItem(
                id: 4,
                title: "Ocean Breeze",
                url: "https://picsum.photos/id/40/300/300",
                thumbnailUrl: "https://picsum.photos/id/40/100/100"
            )
        ]
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return mockMedia as! T
    }
    
}
