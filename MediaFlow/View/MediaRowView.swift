//
//  MediaRowView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 02/04/26.
//



import SwiftUI
struct MediaRowView: View {
    
    let item: MediaItem
   // let state: DownloadState
    let onDownload: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            
            let urlString = URL(string:item.thumbnailUrl)
           
            ZStack {
                // Thumbnail
                AsyncImage(url:  urlString)  { phase in
                    
                    switch phase {
                    case .empty:
                        //  Loading
                        ProgressView()
                        
                    case .success(let image):
                        // Download completed
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure:
                        //  Failed
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                Button {
                    // trigger download
                   onDownload()
                } label: {
                    Image(systemName:item.iconName(for: item.downloadState))
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
                
            }
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(item.title)
                    .font(.subheadline)
                    .lineLimit(2)
                
                // State UI
                switch item.downloadState {
                 
                case .notStarted:
                  
                    Text("Waiting to download..")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                case .downloading(let progress):
                    VStack(alignment: .leading) {
                        ProgressView(value: progress)
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                case .completed:
                    Text("Downloaded")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                case .failed:
                    Text("Failed")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                }

            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    
    // Unique image per item // for demo app purpose only
    // temprory
    func safeImageURL(from original: String) -> URL? {
        return URL(string: "https://picsum.photos/300")
    }
}
