//
//  ContentView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedIndex: Int = 0
    
    //  Create ViewModel here
    @StateObject private var downloadsViewModel = DownloadsViewModel(
        networkService: SrviceAPI()
    )
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            
            DownloadsView(viewModel: downloadsViewModel)
                .tag(0)
                .tabItem {
                    Image(systemName: "arrow.down.circle")
                    Text("Images")
                }
            
            LibraryView(viewModel: downloadsViewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Library")
                }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            CustomTabBarView(
                selectedIndex: $selectedIndex,
                isEntryView: .constant(true)
            )
        }
    }
}

#Preview {
    ContentView()
}



