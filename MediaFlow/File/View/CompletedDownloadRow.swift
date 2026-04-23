//
//  CompletedDownloadRow.swift
//  MediaFlow
//
//  Created by Arpana Rani on 22/04/26.
//

import SwiftUI

struct CompletedDownloadRow: View {
    
    let item: DownloadItem
    
    var body: some View {
        HStack {
            
            // Loaded image from disk
            if case .completed(let url) = item.state,
               let image = UIImage(contentsOfFile: url.path) {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text("File \(item.id)")
                    .font(.headline)
                
                Text("Downloaded")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding(.vertical, 6)
    }
}
