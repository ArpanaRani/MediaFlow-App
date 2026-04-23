//
//  CustomTabBarView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//


import SwiftUI
struct CustomTabBarView: View {
    
    @Binding var selectedIndex: Int
    @Binding var isEntryView: Bool
    
    var body: some View {
           ZStack {
               UnevenRoundedRectangle(topLeadingRadius: 0,
                                      bottomLeadingRadius: 42,
                                      bottomTrailingRadius: 42,
                                      topTrailingRadius: 0,
                                      style: .continuous)
               .fill(.ultraThickMaterial)
               
               HStack {

                   TabBarButtonView(systemImageName: "photo.on.rectangle", title: "Media") {
                       selectedIndex = 0
                   }
                   Spacer()
                   TabBarButtonView(systemImageName: "folder.fill", title: "Files") {
                       selectedIndex = 1
                   }

               }
               .padding(.leading , 80)
               .padding(.trailing , 80)
           }
           .frame(height: 80)
       }
   }

#Preview(traits: .sizeThatFitsLayout) {
    CustomTabBarView(selectedIndex: .constant(0), isEntryView: .constant(false))
        .padding(.horizontal)
}
