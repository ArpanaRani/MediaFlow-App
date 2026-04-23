//
//  DownloadRowView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 22/04/26.
//

import SwiftUI

struct DownloadRowView: View {
    
    let item: DownloadItem
    let onAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Placeholder thumbnail image for UI display.
            // This image is NOT the actual file being downloaded.
            //
            // The Downloads tab demonstrates pause/resume functionality using large files
            // (e.g., .dat files from a test server). Since those files are not images,
            // we use a random Picsum image purely for visual representation in the list.
            //
            // This keeps the UI visually consistent while the underlying download logic
            // operates on non-image files.
            AsyncImage(url: URL(string: "https://picsum.photos/seed/\(item.id)/200/200")) { image in
                image.resizable()
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            // Title + progress
            VStack(alignment: .leading, spacing: 6) {
                Text("File \(item.id)")
                    .font(.headline)
                
                progressView
                
                actionButton
            }
        }
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    var progressView: some View {
        switch item.state {
       
        case .downloading(let progress):
            VStack(alignment: .leading) {
                ProgressView(value: progress)
                Text("\(Int(progress * 100))%")
                    .font(.caption)
            }
            
        case .paused(let progress):
            VStack(alignment: .leading) {
                ProgressView(value: progress)
                Text("Paused at \(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var actionButton: some View {
        
        Button(action: {
            print("Button tapped:", item.id)
            onAction()
        }) {
            Image(systemName: item.iconName(for: item.state))
                .font(.title3)
        }
        .buttonStyle(.plain)
    }
}
