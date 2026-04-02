//
//  TabBarButtonView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//


import SwiftUI

struct TabBarButtonView: View {
    
    var systemImageName: String
    var title: String
    var action: () -> Void
    var body: some View {
   
        Button(action: action){
            
            VStack{
                Image(systemName: systemImageName)
                    .font(.title)
                Text(title)
                    .font(.footnote)
                    .fontWeight(.regular)
            }
        }
    }
}

#Preview {
    TabBarButtonView(systemImageName: "folder.fill", title: "Home") {
        
    }
}


