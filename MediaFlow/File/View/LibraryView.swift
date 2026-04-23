//
//  DownloadRowView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 22/04/26.
//
import SwiftUI

struct LibraryView: View {
    
    @StateObject var viewModel: DownloadsViewModel
       
       var body: some View {
           NavigationView {
               List {
                   
                   // ACTIVE DOWNLOADS
                   Section("Active Downloads") {
                       ForEach(viewModel.downloadItem) { item in
                           DownloadRowView(
                               item: item,
                               onAction: {
                                   viewModel.handleDownloadAction(for: item)
                               }
                           )
                       }
                   }
                   
                   // COMPLETED DOWNLOADS
                   Section("Downloaded Files") {
                       ForEach(viewModel.downloadItem.filter {
                           if case .completed = $0.state { return true }
                           return false
                       }) { item in
                           CompletedDownloadRow(item: item)
                       }
                   }
               }
               .navigationTitle("Downloads")
           }
       }
   }

