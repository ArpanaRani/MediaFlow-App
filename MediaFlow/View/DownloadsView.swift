//
//  DownloadsView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//



import SwiftUI
import Combine

struct DownloadsView: View {

    @StateObject var viewModel : DownloadsViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {

                    ForEach(viewModel.mediaItems) { item in
                        MediaRowView(
                            item: item,
                            onDownload: {
                                    viewModel.downlodadIfNeeded(for:item)
                                }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Downloads")
            .background(Color(.systemGray6))
        }
        
        .onAppear(){
            
            viewModel.getDataForMediaListing()
        }
    }
    

}
